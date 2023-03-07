class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.15.tar.gz"
  sha256 "ee9e3c9bddbc2242b7c59cb63113c951e99ab85e2b90b98ef352b6e7ed92a194"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "838324684e6aa3c96198ee53ef2bb5b80e6325412c31b4b89e4320a13c55f97f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894e14ff033ee93ee57736833ceacad1aba9c35ad1dc61119fcc0b44d81872ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92aa4c445046228baf50947a7d8f2eccc04e7f23e4666bd89766f1e52c66e8c0"
    sha256 cellar: :any_skip_relocation, ventura:        "405c156ee3143305c49fd44dec81ff8c2727152f2113895af78a4de9712a020e"
    sha256 cellar: :any_skip_relocation, monterey:       "55322fcc67352b90e066df35a49db1903e139ed3d915b9bb18e9e98123d5ad1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb788cc57de6d3d7e8ba9766221138d4a5aa4cee618cee40d571e9a9ec5ae6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57baa685d3e52c11cacfa929bf1eb0633b703106bd5d077d6ada5929b345c92"
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
