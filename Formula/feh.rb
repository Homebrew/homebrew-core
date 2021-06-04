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
    sha256 arm64_big_sur: "bd1cbe12b2376078d823854f3a66586533c395fff20bc88d017c1cdc240a5625"
    sha256 big_sur:       "3b21f38fd89c25256e2a94cfc1f4fc66689d6239f239404413ca28cbd2d4e43e"
    sha256 catalina:      "d836e8070c43a927319cab0f715c87a0fd595400b0abf0ae32f4414c1b68842b"
    sha256 mojave:        "eee2a818e7347b3b2a3c8a092ca53852eb747dc334442d85e4c0e1cf7a9b1eaf"
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
