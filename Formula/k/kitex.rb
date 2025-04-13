class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "8979aab324a0e5c71bbc4a985716df2f43079d83e4c61840611bf69ae25873e1"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e977ed56c97e8d0d2c32aad83ecd614b852d05c8fd36559d38e71d7d4a4f799d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e977ed56c97e8d0d2c32aad83ecd614b852d05c8fd36559d38e71d7d4a4f799d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e977ed56c97e8d0d2c32aad83ecd614b852d05c8fd36559d38e71d7d4a4f799d"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb62f18d9cd5aa89b0b6e4c0a0fbfc0562d763e22d451c819b316b62b386f52"
    sha256 cellar: :any_skip_relocation, ventura:       "abb62f18d9cd5aa89b0b6e4c0a0fbfc0562d763e22d451c819b316b62b386f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "835f7e5d40ea401fcdb85aa90244a328d3d44eb46668025144ca1ba6ae8e1f63"
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
