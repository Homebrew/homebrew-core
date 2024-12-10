class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "fb0f526ffc9de885b0ed9a2c7cebb393b36edb14a84957601e70b7ef9a5a520a"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0275469603891f4f73bd7bac02a20065e6f994b5c696f76b93dae81ea765aa46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0275469603891f4f73bd7bac02a20065e6f994b5c696f76b93dae81ea765aa46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0275469603891f4f73bd7bac02a20065e6f994b5c696f76b93dae81ea765aa46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0275469603891f4f73bd7bac02a20065e6f994b5c696f76b93dae81ea765aa46"
    sha256 cellar: :any_skip_relocation, sonoma:         "03a45336f054d693ab21623492d3b51bd80d5db4cc2e91439be4287af9e0af6c"
    sha256 cellar: :any_skip_relocation, ventura:        "03a45336f054d693ab21623492d3b51bd80d5db4cc2e91439be4287af9e0af6c"
    sha256 cellar: :any_skip_relocation, monterey:       "03a45336f054d693ab21623492d3b51bd80d5db4cc2e91439be4287af9e0af6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1a8f8f3844e45d6a89df1be2bf59165dfb9a23f3ae20c8cc309d60f67f4e1da"
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
    assert_predicate testpath/"go.mod", :exist?
    refute_predicate (testpath/"go.mod").size, :zero?
    assert_predicate testpath/"kitex_gen"/"api"/"test.go", :exist?
    refute_predicate (testpath/"kitex_gen"/"api"/"test.go").size, :zero?
  end
end
