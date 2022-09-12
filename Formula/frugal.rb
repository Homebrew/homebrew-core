class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.3.tar.gz"
  sha256 "dc72ac8609bfadacb2610b3c5683318c3a30201098f486417f11d72fae55ee1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49c749430087521db7dccf0ff152c8f030c4d51436e7fcf3a98778b0d63bc0dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49c749430087521db7dccf0ff152c8f030c4d51436e7fcf3a98778b0d63bc0dc"
    sha256 cellar: :any_skip_relocation, monterey:       "06c9081af8bcbe40eeecc80d0b1a106410de943a379402c95537b85d09943294"
    sha256 cellar: :any_skip_relocation, big_sur:        "06c9081af8bcbe40eeecc80d0b1a106410de943a379402c95537b85d09943294"
    sha256 cellar: :any_skip_relocation, catalina:       "06c9081af8bcbe40eeecc80d0b1a106410de943a379402c95537b85d09943294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4740caa1be9e4c6aa30084a771a42e5166487e8ca80cd99bc2e76e435bf01d2a"
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
