class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "545626ebd129da788893d28e3527243d322cf2333c05bc70fa977d5466dade71"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67ac33d408b87dd50b1f733c86fcd74880a6aeaa19d7fadd72f6ae264d56afb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67ac33d408b87dd50b1f733c86fcd74880a6aeaa19d7fadd72f6ae264d56afb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67ac33d408b87dd50b1f733c86fcd74880a6aeaa19d7fadd72f6ae264d56afb3"
    sha256 cellar: :any_skip_relocation, ventura:        "64161dc2ebcada5debac00cbf8ae14b24797942a0c64777fc2a571d5f1a6cd97"
    sha256 cellar: :any_skip_relocation, monterey:       "64161dc2ebcada5debac00cbf8ae14b24797942a0c64777fc2a571d5f1a6cd97"
    sha256 cellar: :any_skip_relocation, big_sur:        "64161dc2ebcada5debac00cbf8ae14b24797942a0c64777fc2a571d5f1a6cd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b525955920d60acc49e11adcc29437e10d9beec11bc9454522adff162a9681b0"
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
