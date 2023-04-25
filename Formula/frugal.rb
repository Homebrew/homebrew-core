class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.18.tar.gz"
  sha256 "fcb3889cdf3385c66bc476b8610e0e04fa3cd9fc3e1844113e3332b8e3b4712f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "684cea05683e6406f4816a4dcfc4197996354835c8557fd2f7c38e261396102a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18ee6fbf5be84bd10f6ff7416edf0457e2be67cc1aadf51aa9140bd7ab38acfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c87c67edb9e496594c02a517d264e246d877ba376e839186c2da4ff8270429c1"
    sha256 cellar: :any_skip_relocation, ventura:        "398f41828ecc4e7b44a64a52ac4258cc8dab4a918b43db6ccba8e847c5c17252"
    sha256 cellar: :any_skip_relocation, monterey:       "d9fd8ef657a2a0544a8ad006f3fc4610a1aa975f6982039e8e59b641b0154542"
    sha256 cellar: :any_skip_relocation, big_sur:        "ead184c1e05f0c81c8dc635f8ad62eea639961d214caf88721346a1e2fedeb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da298de87fc001dc9011dcf46aa2e8a2304654761f667c8242b29df83bba809"
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
