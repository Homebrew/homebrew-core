class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "748d1f5f8f9a96d293e49d83e02cc4bd51b7a0f74ccbeac0de16f21e4b00d996"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f238af142c3494e560def4808196be3f80ba1831126243bb680af54b263d459"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f238af142c3494e560def4808196be3f80ba1831126243bb680af54b263d459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f238af142c3494e560def4808196be3f80ba1831126243bb680af54b263d459"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a32d3bafbaae26e40b050fefee8c47164ab765173ad1fa27e61f3dd4e839d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86883041d650d45b7cea432cb339d8e05268fba84f2f1d115006877ce5c796b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1149dfbbbe8fff9e7d6bf64bea24789b58d91e3068de2ef80844c4d217a706f9"
  end

  depends_on "go" => [:build, :test]
  depends_on "thriftgo" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./tool/cmd/kitex"
  end

  test do
    output = shell_output("#{bin}/kitex --version 2>&1")
    assert_match "v#{version}", output

    thriftfile = testpath/"test.thrift"
    thriftfile.write <<~EOS
      namespace go api
      struct Request {
              1: string message
      }
      struct Response {
              1: string message
      }
      service Hello {
          Response echo(1: Request req)
      }
    EOS
    system bin/"kitex", "-module", "test", "test.thrift"
    assert_path_exists testpath/"go.mod"
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_path_exists testpath/"kitex_gen/api/test.go"
    refute_predicate (testpath/"kitex_gen/api/test.go").size, :zero?
  end
end
