class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://github.com/shenwei356/csvtk/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "b8ccf2b86c815693af1c7d743ca711a68fcdde94d9a9279ac8557fdffa3f2fc8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb893a0139d975c854d38b7002391a413f7e8437e2e077a6ddbe7f0860f5c756"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85d884da7d8fd0d6ed0d53eabeccdb900baeec93522b3f817f3dfb1c8a9e2d18"
    sha256 cellar: :any_skip_relocation, monterey:       "869f5b931d4e0c089dc4a05c1dde8db0dce77004b41ff115e0db3dd613d3a545"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2869fb31ea0a291dff303db08ee8387cfab96ee7e77fe98c82511c6b5805613"
    sha256 cellar: :any_skip_relocation, catalina:       "1d9d5d3ecf0c81b1162f88813f871265ea174ae2535624ad345c1e52364ca692"
    sha256 cellar: :any_skip_relocation, mojave:         "0e0b648de5a24b410a9d56d663668741cb7429e1295ed1cc120014aaa516c961"
  end

  depends_on "go" => :build

  resource "testdata" do
    url "https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./csvtk"
  end

  test do
    resource("testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end
