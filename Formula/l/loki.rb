class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "05c5d23eff751b9c4f4e49918359e35b7ba840a5b504e3eac0befe4ad94ad464"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0721a615a9e6c1f58bf845ff76d59ff7460e85b1b299d64d68ee108169928e04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b6ab94353e0eba23fca400c2a2c6aad5ff7c8d48bec92049ee0022d1919a7d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a073b3c0a081610ff3647eff70ef46a505cc84ce36188eb325b268805872b596"
    sha256 cellar: :any_skip_relocation, sonoma:        "668547c70181344fe16bc664cc44b1a7bee46f4ed1c57ecb4e63da32e098e7c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a920f1f58ecfcbf27beaceb85e7844101dd4fee4ada75a97046aa6646a6f030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e85c71f7aa49abe94ea5c84f864dba40e3ff665aed15d2889adf30a8c375681"
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

    spawn bin/"loki", "-config.file=loki-local-config.yaml"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
