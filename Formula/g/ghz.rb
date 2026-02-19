class Ghz < Formula
  desc "Simple gRPC benchmarking and load testing tool"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/refs/tags/v0.121.0.tar.gz"
  sha256 "d92ed00a2cd1be3b14fe680e1615e9dace4fd4cf6d679811173ae7f2611ad762"
  license "Apache-2.0"
  head "https://github.com/bojand/ghz.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb0c6428ac5a6800e2ce447b2a6f316421953e830d6c64286db3952c28819653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb0c6428ac5a6800e2ce447b2a6f316421953e830d6c64286db3952c28819653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0c6428ac5a6800e2ce447b2a6f316421953e830d6c64286db3952c28819653"
    sha256 cellar: :any_skip_relocation, sonoma:        "522c533de7d3e311a24acdeea0cec1d81aaa51c839903747d05e49ce7072d188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cdd2ae3ae95484b3c966df716b68600f4e539980496749871cb57f5196dc71b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "652cc343f99d8d12144f0395b9fda62d7c103591d36ae3453594dcc3a7de564c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ghz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz -v 2>&1")
    (testpath/"config.toml").write <<~TOML
      proto = "greeter.proto"
      call = "helloworld.Greeter.SayHello"
      host = "0.0.0.0:50051"
      insecure = true
      [data]
      name = "Bob"
    TOML
    assert_match "open greeter.proto: no such file or directory",
      shell_output("#{bin}/ghz --config config.toml 2>&1", 1)
  end
end
