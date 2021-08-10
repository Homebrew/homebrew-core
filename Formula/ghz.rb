class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.99.0.tar.gz"
  sha256 "474c84f9d8cf7da5db177f12b0f0f242b500ff42363323bed39f73b4a318bcc3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df7ff8d875e96c7aedd85c3edd4dc0d28041d3c37d984d65e358811da5ed5f2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8812340400cbcdffdfcfa52c4ef1df6e31d649adae06b9efc0d788442868146"
    sha256 cellar: :any_skip_relocation, catalina:      "a741bb5716cca02cd413cd8a1e0420d76c64e953b036a2bc2b1048d0a28fbf20"
    sha256 cellar: :any_skip_relocation, mojave:        "b1b9548551478a988b3f589efe214cccdb67bdab85751ee54f8f594cf051e8a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b11c17c5a21001c83691ebd1e6842b3e2c4dcc39eb865152273dd159bfbcabb4"
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
