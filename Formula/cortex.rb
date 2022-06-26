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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16a5cfa0b7e9ee7ecb3ff74712ddf1ef064622eda638fe7cd39c4f1f345e6607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b50a50da4d491cdd184b432a31f17194f5c529fa04a236f2035a4844fc6024d5"
    sha256 cellar: :any_skip_relocation, monterey:       "f17c643b312242f03a84b4dd39d270213407bf3d0cda771ec15763ad88ff9842"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc017ba00df3b41e00cfb2e4aac7efc312fb5f83aefc6b7486ae791894dc5060"
    sha256 cellar: :any_skip_relocation, catalina:       "1f4a8d739fbfecbffe21fe4cfd6225436d85013658a282d557ead7f09ac83750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0c836828b0067478d9d663b94bba17966f421237fc2113cf06cdef6b0feeca1"
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
