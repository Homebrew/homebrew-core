class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.23.tar.gz"
  sha256 "7e2229134dcbd4f6d8b1b2e77f6c7d3ec4b7fc22f4f20fd37879481a306badf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a222c3c61c111994283ad8252d05caef7cfbe14f70a42b0193791672b204b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54c11de762372502f703f093292b752098ac73c29a8145bfd755300ac1b8827a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ba72a72fac10017ae64cab527513659de38b023654b24f3eab658f4083cff38"
    sha256 cellar: :any_skip_relocation, ventura:        "2b32c90b75db3ed4ee3969ed9626bdc406d05dd863f54a6c98a7fc4ec7ef4022"
    sha256 cellar: :any_skip_relocation, monterey:       "e28908d780d2299497a660768a39b9fd999eb2a83c18b5af151e2b20a8f90b97"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ba3571c32fba1751745b7ac0315774d890b4705071522fda997b9fbb3664a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1e75ee215c0269eefada0f97d36f2454a9ff4b522311ca5b458669a6fba17e0"
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
