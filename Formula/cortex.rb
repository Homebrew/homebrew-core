class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.10.0.tar.gz"
  sha256 "8c75d723f31da3806a73a8a869a576cf6a0396aebe6567e96b675eb4df6d9849"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63883c16aefe97cc4a4c5ba3b04969cea0bc1bbba16e5b0adf9baa626e5a2f9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "634ad3f91c86e951ada9ac32b16a05af3ea8c91e07bd18fb261b39ee0c2c5baf"
    sha256 cellar: :any_skip_relocation, monterey:       "7f01f63d58aba4d6b155b1acbd187df7c6d74e5a72214fc957fff283c6cdb7e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3044d8217250a03b90158a8600b03e7cfb70d3de3b19c14141d748d70ba51c22"
    sha256 cellar: :any_skip_relocation, catalina:       "d31d8bcb6cab6eb3b5679972e41d0a272355650d7fed1a8c1a726364aa8cd871"
    sha256 cellar: :any_skip_relocation, mojave:         "a9ff8743b74f1cc4286b174446d22928c374a0d907711b05be3ef5dd83481c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "960b349470adc18fecda3f24ebbe9871bcab6a8a112c387ab7730c8d1195cc60"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cortex"
    cd "docs/chunks-storage" do
      inreplace "single-process-config.yaml", "/tmp", var
      etc.install "single-process-config.yaml" => "cortex.yaml"
    end
  end

  service do
    run [opt_bin/"cortex", "-config.file=#{etc}/cortex.yaml"]
    keep_alive true
    error_log_path var/"log/cortex.log"
    log_path var/"log/cortex.log"
    working_dir var
  end

  test do
    port = free_port

    cp etc/"cortex.yaml", testpath
    inreplace "cortex.yaml" do |s|
      s.gsub! "9009", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"cortex", "-config.file=cortex.yaml", "-server.grpc-listen-port=#{free_port}" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/services")
    assert_match "Running", output
  end
end
