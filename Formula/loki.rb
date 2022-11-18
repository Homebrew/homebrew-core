class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.0.tar.gz"
  sha256 "fcdf692b117bd412e4b5a61811d92f18b3a02db6e3802e6abec0c4f584d31861"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "345a96340b635bd094b7bcb1daf6e18bf474edf20e9bf2ecf9b7bcc1e6be3f22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29955d163d41df6111d5937b86267a633ba82397b4870d1a47098f42cd1cd7fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8db78d3279144b195fd65534adea8df0c0f022098360d51d5f13a7b23c7bc6d"
    sha256 cellar: :any_skip_relocation, ventura:        "652d3de1381cbc5e0ecf9ae0d89ea15a030d41ea724a5b9006414caacde7d73b"
    sha256 cellar: :any_skip_relocation, monterey:       "76d9fff6c88459bb2fbf4e167f799ca0cdd3c26aeb430fb7e4953d89fe5535a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "341ed4a7d0dd6cd8eea06bc233211b848874e8a638f2bbd43c8132addeff8461"
    sha256 cellar: :any_skip_relocation, catalina:       "6529d93c90a1c48180e73d238ff8b28f0cace453b18ca320c04c2b984bfcceec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5884152cbc6465b0e668e3100944b58a4c10f456849b6c7f45a37ce2059c77d2"
  end

  # Required latest https://pkg.go.dev/go4.org/unsafe/assume-no-moving-gc
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
