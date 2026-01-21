class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "c146702d3fb18be130d6a4f4fd97bfa10f545c0f23e415b42967f1734382bb6a"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13cb5b9f4c7301ce8cf8fd340094ee7ae188455a4ae9a38779a98c8b4e7c99de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13cb5b9f4c7301ce8cf8fd340094ee7ae188455a4ae9a38779a98c8b4e7c99de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13cb5b9f4c7301ce8cf8fd340094ee7ae188455a4ae9a38779a98c8b4e7c99de"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b92d1514085cab6f6546c78c8e4b3966be3ebc207d9baf25c56df51f9d8d639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e75c95af42e81f667e3e2d6af8f547450183fea76d8bbc2ed03da05cc9a4b4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55ac7e03d8a192ccab47243eae1a88895b66b6a94b290754866586d1e5ad1aba"
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
