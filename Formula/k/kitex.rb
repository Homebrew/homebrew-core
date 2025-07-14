class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "a860e6ad8ff5207d9516299d3eec055042b2bd99a3df83bf3c32064c79976a46"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "825df4134a567ebd0cda77ffd3405559dc6de97306ceb5bf237cce4623d3a086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "825df4134a567ebd0cda77ffd3405559dc6de97306ceb5bf237cce4623d3a086"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "825df4134a567ebd0cda77ffd3405559dc6de97306ceb5bf237cce4623d3a086"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f265a5fa49a06007356c7b93dddfb1a946bc40c65baa43b5dc963cd17ab8561"
    sha256 cellar: :any_skip_relocation, ventura:       "6f265a5fa49a06007356c7b93dddfb1a946bc40c65baa43b5dc963cd17ab8561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab48b9d13d512e833b899f677e027c41ebb6eb9248146288a69b7ec1f9c8921a"
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
