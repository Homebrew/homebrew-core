class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "6b446bb840b04626be6048f02fdaf899e613ada2038f2f169ec0a1262eee219e"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8bb0db0325c188f59d389d0e18fa43cb64ac53aafc7c82e687fb5babe32dee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8bb0db0325c188f59d389d0e18fa43cb64ac53aafc7c82e687fb5babe32dee2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8bb0db0325c188f59d389d0e18fa43cb64ac53aafc7c82e687fb5babe32dee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe63a88fe601260e39785d72d37273aac35e8368b28b644416ae2b33f2eedad"
    sha256 cellar: :any_skip_relocation, ventura:       "7fe63a88fe601260e39785d72d37273aac35e8368b28b644416ae2b33f2eedad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce5e4e6fef19a4785d6e6487f2ff64e393026bde795ae2c3c18b9e1d781e4f2e"
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
