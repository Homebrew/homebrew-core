class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.110.0.tar.gz"
  sha256 "254463fd61b316f709a84b184da5309be1c0a4a442145665da26d9ad98da1351"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "936b4059282a81110efce72237763a85ebb956179f01502e0b4391ecdd1d6011"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcd54221051293152c697485a29d1dfcb2462fde317675cffcb4e8b72e4fd941"
    sha256 cellar: :any_skip_relocation, monterey:       "db4deeff23a9015f322888965dc7a004e355df64449b7ab9990be9c1803c8408"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb31627a411d3efa2067979b3ab1212e4a5115490ab5a1aa191f1a1d08eaa610"
    sha256 cellar: :any_skip_relocation, catalina:       "1211017d2ca0ac91eb457de792f37afe3fad2a887089ee10c3a09d86d85fcb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c768990085e05e9fca28ec7e0187b451432e01c3d4444962f1c0271a500f8f1"
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
