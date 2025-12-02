class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "7080a1f8eab0f2c2053e634de08a1adb391bcb52eaa7203a647328592d546e4c"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7311d391e48469dad71f05433aa74841f4ed487b8d5504cd7e7d1529a2d15a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7311d391e48469dad71f05433aa74841f4ed487b8d5504cd7e7d1529a2d15a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7311d391e48469dad71f05433aa74841f4ed487b8d5504cd7e7d1529a2d15a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9651d398bbcd16fe2b6ad1d1e67a3c5103e1333db879bd37db54d39ade5d3a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e52beb23172c50ff0362988ca203b3415bf31eb7706ddf782b5c0f32a7b7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e07cec3ad344f14b61590f400a1df98820b19697da1344780729747bb0534704"
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
