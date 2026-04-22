class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "ac045e616b4e92c64eca73c0eefdea1ef33b54de04cd2c9c407ef87ad2510a4d"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72528a1d6f60169697b598b8809e847bb184618686c3bc617e5860777c6114d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72528a1d6f60169697b598b8809e847bb184618686c3bc617e5860777c6114d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72528a1d6f60169697b598b8809e847bb184618686c3bc617e5860777c6114d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5fb2ceaa564e3b9b2b3ef4bd25d795ada625315e5187e4a0b9c59c91f4f5d5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1d1373c2cb7e37cf1e82155f1b8f57526ef0710170e871f193542dd379e95d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc9645cf6f285447d780760dfb5daa4f2492d29bdd0c08dda106193d2a51131"
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
