class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "debe7456676657e8f0bf91abfe24564bd084e0669a413800c8f95debc64a12b1"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0984f21da81637d3b990eade09d3020f7319efcd82fda54e8f2db10925e64c1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e7a498959152a23a0d8e0903e162dbb5d1977f5408b0ba544f6a66859ea8c61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbea5e8c46c7f21882c34435708e6348679a905b039271f50765bb7f6390f911"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4f46feda8c76c9ad60d8f4c402c54bdb310250b3f95bec44a239ed79c335b06"
    sha256 cellar: :any_skip_relocation, ventura:        "80bf9f573ff56b16662bafe00e480b94237fbd9fe850d797cb18f03d1198443f"
    sha256 cellar: :any_skip_relocation, monterey:       "ee12e7432ffecb40b0a286f5f5cb2aa2a444617927027a82fb852506c38fa8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "937d2279596b435a172ffc0144bcc0e94bef5abcfb90460eced0030cd3f09393"
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
