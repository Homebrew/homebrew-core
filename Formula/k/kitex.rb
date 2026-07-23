class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://www.cloudwego.io/docs/kitex/"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "89a82cb1e86b2c8f7cdee8d73ba243674d159c22a23d33c398291a5cfd79b725"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be43c1e06d59d842f383f33b47936081dfa7b77135cb9da4b038fc57f15378cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be43c1e06d59d842f383f33b47936081dfa7b77135cb9da4b038fc57f15378cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be43c1e06d59d842f383f33b47936081dfa7b77135cb9da4b038fc57f15378cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0ba4c22202fc0250924a741a6714f0065301b6d041e2a2db3f7473789493292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b0bc54797bac50553f1698389b1e1bfba1925ae2bed74ae3d2c032ce477274c"
    sha256 cellar: :any,                 x86_64_linux:  "5f7c68f560204daa51ae253db75092409469068ae00c5bae751d9e9ab8bde6d4"
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
