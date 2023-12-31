class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "c67f351ddc8eaa66bba5b3474d9891e9ef8de4bcd89e8a4fd0cfb413bca8fdc4"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d12fc47815dffdbc1ed1ed107e71d0eb45c52863af4faafcd95137bf0145e571"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a232126ffcae4fdf98a279cc0ffe0412b46a4456d079e8d45914b3f485c90244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b636603b3d574fd1ce791623987642389323ce263d3f3f862ac8285747b18935"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2381f403c2d0101e651e0f3da4db2e52e9c1951d88ca44614c846aca4b77d11"
    sha256 cellar: :any_skip_relocation, ventura:        "b2255d38bdcc7961ac3a45e5ac4d13029f53cfdd984b9dbc747f00e96c1136eb"
    sha256 cellar: :any_skip_relocation, monterey:       "cd0f88b1f8364db6faea0a1b2bd31fdb538ea79ef09adfa66a2b9f83af5a9f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8be1e0de0bf34665747a951401ccdff64ab3a1a5d6e1bffcffb2a81e084bb1"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
