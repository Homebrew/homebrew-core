class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d52be74eeb2b57bd1a78d3ecc3477888f6219a2e613eb51c14e8f203d72333c8"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b1768e04e267d6f3b0e120766b93e020ecb77e8578ba26b3f11568e305ec76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b1768e04e267d6f3b0e120766b93e020ecb77e8578ba26b3f11568e305ec76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0b1768e04e267d6f3b0e120766b93e020ecb77e8578ba26b3f11568e305ec76"
    sha256 cellar: :any_skip_relocation, ventura:        "0855b776c6c3ea45cd0d9385951e688acface97e297c76bde3469c7de6dfdfd1"
    sha256 cellar: :any_skip_relocation, monterey:       "0855b776c6c3ea45cd0d9385951e688acface97e297c76bde3469c7de6dfdfd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0855b776c6c3ea45cd0d9385951e688acface97e297c76bde3469c7de6dfdfd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "133bc4177e056083b289d8d8851cbb427c2f58f289a143c15616c5bca08cda99"
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
