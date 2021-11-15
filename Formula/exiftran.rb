class Exiftran < Formula
  desc "Transform digital camera jpegs and their EXIF data"
  homepage "https://www.kraxel.org/blog/linux/fbida/"
  url "https://www.kraxel.org/releases/fbida/fbida-2.14.tar.gz"
  sha256 "95b7c01556cb6ef9819f358b314ddfeb8a4cbe862b521a3ed62f03d163154438"
  license "GPL-2.0"

  livecheck do
    url "https://www.kraxel.org/releases/fbida/"
    regex(/href=.*?fbida[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "91110d661f406a9b3007b9385bf89c9bbe879f079aca23c92378204b2e855ccc"
    sha256 cellar: :any, arm64_big_sur:  "c156611ffc675a4c47a0d7ef649927deddba30fccd033220613a8a9e849ef351"
    sha256 cellar: :any, monterey:       "8f3506464babad05e20109155fa06470ded7a49078810a045d22fe5a89e7bd78"
    sha256 cellar: :any, big_sur:        "9938f56d95feeef58aebf691798d3da5c730bc34f7d1b36306315c2a5e60c4f8"
    sha256 cellar: :any, catalina:       "b7df03be0559eccfeb4505d5302101b674ed4893fc0fee18ad869dcd198a3d25"
    sha256 cellar: :any, mojave:         "3f595126500f20ed6bc8d25733f52e62073f67cd3bc655d231154ff0e614b062"
    sha256 cellar: :any, high_sierra:    "155e492e4c82c7e06be60966dcf343832e456bbc47cd1293ec1805dd3e47e42c"
    sha256 cellar: :any, sierra:         "11c7c1d5a5e5a16b7cfd9cf8004cb1fd3f141974462df036ce09539083eb3d60"
    sha256 cellar: :any, el_capitan:     "8ad9b01ec63c6ebb4488dada2d973b47756ed839fe96b083a9b49ec85c0eeb12"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "pixman"

  # Fix build on Darwin
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/185c281/exiftran/fix-build.diff"
    sha256 "017268a3195fb52df08ed75827fa40e8179aff0d9e54c926b0ace5f8e60702bf"
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end
