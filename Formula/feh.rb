class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.7.2.tar.bz2"
  sha256 "84718fd2720cf540d245768494fe0eb4e598f44b39e2326bae8c368a829c8258"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6dd1d3b34ec57e96d425600e9ff9c934356d9303c0cb08874928fe79a810ade5"
    sha256 arm64_big_sur:  "f4867d78c1eb739f3ae5c99a228a3f2a4933071ad59923bdcba47e7f1439ca84"
    sha256 monterey:       "13ba55255d8cb9fe29e8a30130c4216925aeeda03e94ee03e37966135e541809"
    sha256 big_sur:        "a37c2f2c6a11d3f35b57cf5068a948b2066efd90a1969b3a0074323b1dd35989"
    sha256 catalina:       "4c5c9aa1cb0b260c6b0df9af37859cecc40d60007b4743fe1e90cbdae87dc8fe"
    sha256 mojave:         "879ae5dfc7e464976b39420290d06f6238e9037dd24e9e387308221fca0b81e9"
    sha256 x86_64_linux:   "dff9c6adbc299a3fd0278bd06435261772b1936a2ce1da814f27dc5f3a89876e"
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
