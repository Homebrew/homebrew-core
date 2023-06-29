class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.24.tar.gz"
  sha256 "70e14552bdf59608f35703deb6f6132fa376cbdb8173c07efdd59fc610ed12ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62bdd97f6129bf2228f5af11f42f0866229e84b0b6a171601573a80be5262f56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d6661504e4e3821300e8f26ee81237be48f5202d3d75ddf4a67156a59091dc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dd19130ac3ee85f6aa736eb40841bb1ecbe0f17bc0c90564d921d7377113800"
    sha256 cellar: :any_skip_relocation, ventura:        "daa32b9816a9c64194cb3a5dabe5ff214de2eabcbeeb543fc0e1706416b8e3b8"
    sha256 cellar: :any_skip_relocation, monterey:       "194ee6404d2a5f484a6890f265edce2fcfad674fa87ae6d50fd8083feb77f4aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ba2c73b605a58994e961641cdeecc92c042e200d4dad6538d6a7b179c543a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea26909ee36f9c9cb10929a5fe147d184190f20700efb0a2c88c9f7820c57ee9"
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
