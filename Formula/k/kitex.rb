class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "46d2eddb728c4f27ac6a3a0d3a694b9932d4557961130a37c6d82977dae09bc1"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f90235664b0ea4c656f79b3d038724b1e5537802a43d41e439071b6ff51eed32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90235664b0ea4c656f79b3d038724b1e5537802a43d41e439071b6ff51eed32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f90235664b0ea4c656f79b3d038724b1e5537802a43d41e439071b6ff51eed32"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba53d9907cfc70e017f91ba88175382dfc6e973703667d0c953313452b36c844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dd67b3994fcde79de6509dc5c87f517e090799fdc8d4af3971ad4f9fe28492b"
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
    assert_path_exists testpath/"kitex_gen"/"api"/"test.go"
    refute_predicate (testpath/"kitex_gen"/"api"/"test.go").size, :zero?
  end
end
