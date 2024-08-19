class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "693ad24d29e19c57cad30e6dd800e59b7a8997d1d892c6bce24c34f18d19d352"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ae45530c182bca7a318f2ace735bf897e58470b0fc141d32d48c7465180196b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4568a990dbeba87386385aad6ffe0df9c051fdf6f8e13f76d4cd158bc7cf65ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4655fd8f7742065ebffa143d394d230e2a55780e4640b09cd2291fcb1fe79a1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e3d15973c44ceacbe6d39693655fcd27b46c09ab17b3a4bb3ebdb5d97b1a9d8"
    sha256 cellar: :any_skip_relocation, ventura:        "8fda35e5ed5e925a5504daecee30fd77365d7f705f9551ac26824927d7f3d9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "d1b1c5c10b93031de31eb7c75d59efab7473ca62b31c6f7e8e663c6287e78a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf1f097a528aa55502ce7319f4411347996bde6935425be85f64417a7877354b"
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
