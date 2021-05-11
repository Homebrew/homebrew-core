class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.7.tar.bz2"
  sha256 "07cdb1076c3b7777064cf081f722346600aeefeb568cbca58575777969a6bb41"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f907275a410ad5d1766936c4e3a88d970a8b71bc1a0acc029e71c36dfad9569d"
    sha256 big_sur:       "cc6e98325f1233c484f700f04cabb9b73061e2d1cb6c24de954ad33a9a4cfa7c"
    sha256 catalina:      "a26d86d34fca0fe0a87aa9330e20614a5c1aaede90d79a8fc482fc64259008cc"
    sha256 mojave:        "4328378783d1519676d8d53be065cd9ee52e583b9e917fc507afeff30eb85f2f"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
