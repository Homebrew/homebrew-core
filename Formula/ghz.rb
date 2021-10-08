class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.104.0.tar.gz"
  sha256 "045b2e0194f46bc610fe220d5eb953987c5d9f0a6ff2c59cc642803aaf589256"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27bc4cd5b1dc602d4962b0adc785ef6a2833df4693a24c53e890bcf614841491"
    sha256 cellar: :any_skip_relocation, big_sur:       "c10f8bddead0fa5990a3a5d6117973f15a7ec15da4063c15a09b80931c434d93"
    sha256 cellar: :any_skip_relocation, catalina:      "86bd9bc0b1189c74b5ad811d71a7872199bb1c1b173e7c0a3f774dbc36d5da05"
    sha256 cellar: :any_skip_relocation, mojave:        "fbc5473bf4a360976c1d84e8364d2013bc5d80008af1a23bf231319539350950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbe1ef2697313437c3c1aa513a209e362bad11d054bd81d0b90b34eb3351541d"
  end

  depends_on "go" => :build

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~EOS
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    EOS
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
