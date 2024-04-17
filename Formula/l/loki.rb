class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ef44e222086dc2e580394c2a1148f7c0bc5c943066a0d18498f2bf6e64ef5a1b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "752804fc6ba24b63896ecfb8da546a7242f5ac6f34e69d958c3ad9f3e830a9fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87289956659e5340590f7fec3170f0e5b195d3d8685ed1f2d77ebedeb1ab0e30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9298d1905284620f1351ecc3d3a1fcd2f2579efb8a1e1111b8f224f9595b0094"
    sha256 cellar: :any_skip_relocation, sonoma:         "e03d8fd62afdd4157d7a846297885f817c72ef56e1552aadf54a6e7709963531"
    sha256 cellar: :any_skip_relocation, ventura:        "aac24d9d6e8b204ab2101b105c3ce1fcc9f144085fb21edfc55affbf599c6c45"
    sha256 cellar: :any_skip_relocation, monterey:       "23802a27b8e22d6dc6ac9a2115a9caae995d6c1c745e33dea29cda77987e5721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17e563909bcdd1e3489580605221e3a6fbac303d809b00c3fb078b8b58856a5"
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
