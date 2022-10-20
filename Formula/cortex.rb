class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.13.1.tar.gz"
  sha256 "aa742a608c8201fcca41061cd2264d1b8eebe61c22259a5289de3a226aeee7e3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e575c8db34f377faa212eec5f0ec7d478b3daf4cf10bd2698a9a1f1faec8332b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "344f842dddbf81a1169f8b53ab9e550101e088177b328472642a583528e9b166"
    sha256 cellar: :any_skip_relocation, monterey:       "f9dcf2a61dbe5bb8312b7853834ab1524b15fac15f7f968c9c690aa93ba9bada"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5ac2445ad9eea5364c0ec13d306965ccf7bf3156e71deaf5fd1eb87a8837982"
    sha256 cellar: :any_skip_relocation, catalina:       "5169ce5a37d08f88fcd7defe6549f83a0cf3da9a3fa84535e6d4e8427abbb5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c6fd5209e864083236ece46e0603f764ac910a47183e08d12e747b89be6f9e"
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
