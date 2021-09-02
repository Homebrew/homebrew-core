class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.8.tar.gz"
  sha256 "7695911bcb09f89a6303dca0309b2c713291f741ca4f9487428df67712312584"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f61b47ab1828890bb88673a25032bd78ce376a6b950a119e07658a6419e984f2"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b295759650bccf6602e923c656dd6ff297a5ce5c29d5937a056a06dde3119c5"
    sha256 cellar: :any_skip_relocation, catalina:      "9b295759650bccf6602e923c656dd6ff297a5ce5c29d5937a056a06dde3119c5"
    sha256 cellar: :any_skip_relocation, mojave:        "9b295759650bccf6602e923c656dd6ff297a5ce5c29d5937a056a06dde3119c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d24515f4b9ca00a9036f50b8afbab15c6473a63c3a866c255bc2e3d90bd3fe8"
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
