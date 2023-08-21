class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "38ad79d0b253bc86f3ca046ce82f3a7575fdb9091fd322913f33793cb4f0dabb"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83281ae3e4d4df30bb029e44627f48b2ccdcdab3d9b57d5c487f5adf8bb7c4d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cb13a1850733365ddacc64c8f49f4ffdade1884f4c66f2f16f93a724786332b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b35412445aeee7362a0006ccece94a192f85fb3b3801907a7152b2d50ebe3fbc"
    sha256 cellar: :any_skip_relocation, ventura:        "6f8ec338ac62657623834655e48807e5db1fab75d8c851d9591f7c07a1cc57c1"
    sha256 cellar: :any_skip_relocation, monterey:       "79961c3473981a42483cd2685b122effb840f41e5846013c5ccd7160a6d8d839"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec9684c3386db1ea9c798cc8083e6211f692b691f17175d7334537a47b27ee99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b7d6908cc3a4ecb7c5a075935bf7d3f1857192c5d06a67f73669b5d9a371729"
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
    system "#{bin}/kitex", "-module", "test", "test.thrift"
    assert_predicate testpath/"go.mod", :exist?
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_predicate testpath/"kitex_gen"/"api"/"test.go", :exist?
    refute_predicate (testpath/"kitex_gen"/"api"/"test.go").size, :zero?
  end
end
