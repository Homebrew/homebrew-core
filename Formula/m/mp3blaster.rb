class Mp3blaster < Formula
  desc "Text-based mp3 player"
  homepage "https://mp3blaster.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3blaster/mp3blaster/mp3blaster-3.2.6/mp3blaster-3.2.6.tar.gz"
  sha256 "43d9f656367d16aaac163f93dc323e9843c3dd565401567edef3e1e72b9e1ee0"
  license "GPL-2.0"
  revision 1

  bottle do
    sha256 arm64_ventura:  "301c45f8598765fdfacdbd773046f77406714c334946c6778cf7334b18004dbb"
    sha256 arm64_monterey: "7ec5e7135245bad785d3267ee2dcca69442a9bf6e8e2922ef8cfd2d4632cdb4a"
    sha256 arm64_big_sur:  "accc717158abb4d7493f4ff6bdd6c3dcf192ba06208efb08f93bb8c0f461d2d4"
    sha256 ventura:        "891ee24c9ab3afd96503c7a0baaf2e20bd3f2fe84f3727eeaf93b62d3de2b39d"
    sha256 monterey:       "0d343b563ad1378a233e2bb1d13207635b92aac493f8e39d9dc0800920d7699a"
    sha256 big_sur:        "6c1f0d720d7451421e8b86dd8f2d910613f7201da6ba56ea1b449b2d2e94aa90"
    sha256 catalina:       "8e52da9fa1ad2780c9fd408222a25eec77a7745a77faee1530edd959173392ad"
    sha256 x86_64_linux:   "2ecc188df98ee829da61e43203f0f1d9601eb7a362b4821638ab08bba6f8c2b5"
  end

  depends_on "sdl12-compat"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3blaster", "--version"
  end
end
