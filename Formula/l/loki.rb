class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "6ebcd323959fcc6b6ec5a466c5a6c975d186c9c3a81b61f3c69cdc8b047c1961"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "682eb1d94d55b20bf9ce67bb5463f8391a2413bf8775902f2ab245d8fd1793a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a0141d6b5a034316224c93ec3af5ac645f42feae3671a74c8433618892cde18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a72b66e9cd6114a12848b5056b1a8c9e0e910dcb0cfee83e87e921da1f595306"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a00839cd9ede4c870b4992c7728667b8beb3aa895d6fbe00717da189cc53b8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "320d0d2572e9b8dcb1b214ad9976d5cddabf5b5c513042848ada489d4f20433f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffb80dff0ce5cfae9f5f01e42ef976e19f5b0bbdcc4edc03cf34ef14fc8f7dc7"
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
    sleep 8

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
