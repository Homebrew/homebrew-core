class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "ec22ace925fc504e53b459e26b143401f4a023f30fccd690f825b808a6df748c"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd3442ef21a240deb4ac56e9d397dd28b869916bbebb45a6df9ac61a2fb000a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd3442ef21a240deb4ac56e9d397dd28b869916bbebb45a6df9ac61a2fb000a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd3442ef21a240deb4ac56e9d397dd28b869916bbebb45a6df9ac61a2fb000a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b961c364704b7e3c79cebe40a447cc2d81b481c662442c4ef75f280711b33aed"
    sha256 cellar: :any_skip_relocation, ventura:       "b961c364704b7e3c79cebe40a447cc2d81b481c662442c4ef75f280711b33aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390ec2b9bd576efcccef4a0153750388bba65389858971aed6e819dc7e9088f1"
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
