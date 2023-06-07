class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "0231cf81449ac82251fdf59c4b721c9ab0879ffa7e920e127c98069d20e2d53c"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44875cb9e3e734121787a6681f168ac3292977139c90daa9090010a3e48f564d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44875cb9e3e734121787a6681f168ac3292977139c90daa9090010a3e48f564d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44875cb9e3e734121787a6681f168ac3292977139c90daa9090010a3e48f564d"
    sha256 cellar: :any_skip_relocation, ventura:        "706ef4b2dc563f00f1545173da50c2bc33427a01feb87c0bb4970f18516a1987"
    sha256 cellar: :any_skip_relocation, monterey:       "706ef4b2dc563f00f1545173da50c2bc33427a01feb87c0bb4970f18516a1987"
    sha256 cellar: :any_skip_relocation, big_sur:        "706ef4b2dc563f00f1545173da50c2bc33427a01feb87c0bb4970f18516a1987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ab88dba11b568db028b37c9421e6dfa809a0d011745b6c8bf0dc6ed7e2087a7"
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
