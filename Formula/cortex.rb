class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.11.1.tar.gz"
  sha256 "7219bac21a49af6b3c3dd691aa867573f8b8d89f91a4433bfa185bc775ec3d3b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04425fe81f84b9b1446436a3178f68e109ec93bcf66d34c2f4bc200ac2163e82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd9bd6e9a71f685770a301499138566acec5635d6e4f3d79e605677846fe49c1"
    sha256 cellar: :any_skip_relocation, monterey:       "fc620132236a3824c4a42976715ac05257f7442b42a3f0420a803ff2fe298576"
    sha256 cellar: :any_skip_relocation, big_sur:        "c28f76b6e28fa84d1d92c53be0ba2aa9183a956985c6e9b59d43fdb1a42051d3"
    sha256 cellar: :any_skip_relocation, catalina:       "1e12a54c55921413b668e370e722a12f9dcd0b611b7129024e2b82eb7314d596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "019b1294b8610afca8652596b9c11fc691e1e05956040a8fa39e6c693f663ccd"
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
