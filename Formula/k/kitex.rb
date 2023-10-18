class Kitex < Formula
  desc "Golang RPC framework for microservices"
  homepage "https://github.com/cloudwego/kitex"
  url "https://github.com/cloudwego/kitex/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "663fcc0c18da67cf8cd37667c1dd876bcdf018714f9beb94171af75ac2bf46d1"
  license "Apache-2.0"
  head "https://github.com/cloudwego/kitex.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "feeab8d97158b0a2447a5cce1711588beb507cc8613357a0243b6286faf61cb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ab9df979f5b1b87a295c25ed2180972ebfc6dafc9b1e439a639c6ed9898242c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e78affa3272df47abed98864a67c2eb052c7765d27fd29ef80f44848c0f48f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcd1ea5a65e7497f300fb9dbce4ef7f4cde2fa1d66b232ebb8dc0374fb6329bd"
    sha256 cellar: :any_skip_relocation, ventura:        "d00c91abacc171b0d2cc9860c60d65dedb48b016fc127bdd1d70cd8977cd4aac"
    sha256 cellar: :any_skip_relocation, monterey:       "3d6bae2840b082c956c8e8df06e52a9106542d1401ceaf89bac627290daae6ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6cb741fbf572cfdbddd654ae73ae20ae5a1771767d1e4315828819174f1b3ec"
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
