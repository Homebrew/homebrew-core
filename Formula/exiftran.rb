class Exiftran < Formula
  desc "Transform digital camera jpegs and their EXIF data"
  homepage "https://www.kraxel.org/blog/linux/fbida/"
  url "https://www.kraxel.org/releases/fbida/fbida-2.14.tar.gz"
  sha256 "95b7c01556cb6ef9819f358b314ddfeb8a4cbe862b521a3ed62f03d163154438"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "155e492e4c82c7e06be60966dcf343832e456bbc47cd1293ec1805dd3e47e42c" => :high_sierra
    sha256 "11c7c1d5a5e5a16b7cfd9cf8004cb1fd3f141974462df036ce09539083eb3d60" => :sierra
    sha256 "8ad9b01ec63c6ebb4488dada2d973b47756ed839fe96b083a9b49ec85c0eeb12" => :el_capitan
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
