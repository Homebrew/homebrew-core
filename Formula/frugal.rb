class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.14.tar.gz"
  sha256 "07787b6f8a26799dee4abf6cc92430e4f31f3e02c63abb3417a6dd7f309f0391"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f70b5f7f18736c91b28298f14fc3a1a44ff73b4c14b5a9a61ceadecda740be6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f70b5f7f18736c91b28298f14fc3a1a44ff73b4c14b5a9a61ceadecda740be6"
    sha256 cellar: :any_skip_relocation, monterey:       "f7a4adab8c0f86be813998450c0ee096730a70c265cd61a84f7d217203beb82d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7a4adab8c0f86be813998450c0ee096730a70c265cd61a84f7d217203beb82d"
    sha256 cellar: :any_skip_relocation, catalina:       "f7a4adab8c0f86be813998450c0ee096730a70c265cd61a84f7d217203beb82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d37b71b2512786dd9b7d588c75174aa5a9f156fa065ad704d46d875d7593dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
