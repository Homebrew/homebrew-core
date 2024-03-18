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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e74534f7b560a7ceaace3099486d221147a4ab4f2462ad3e59bfccaf75b3526"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e6cc4768f55113672034ef16f3fbe57767fd17a027ceea22ca9a42042d839f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aee5644007a5c314df4f65db013794229bdb3dd1c90cefc836aab379b080a4a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a38b2849ba0c23e8f314644cd686abcfa2151c60f40fac0b812abbd31b6a74a5"
    sha256 cellar: :any_skip_relocation, ventura:        "fcddce67344250c6aecdc91c4e48a633a5f59edb0490561028e48ab90094bdb7"
    sha256 cellar: :any_skip_relocation, monterey:       "14e3074aa8b60e7a5bc552fce5b2c8a465acbccc172fb84f4517083c4a55bf84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6e30e4e4b17bb7d306dfcf7b15cae785482de907fbed916dd4ad4430ebf0e8"
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
