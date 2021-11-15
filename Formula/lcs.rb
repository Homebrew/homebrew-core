class Lcs < Formula
  desc "Satirical console-based political role-playing/strategy game"
  homepage "https://sourceforge.net/projects/lcsgame/"
  url "https://svn.code.sf.net/p/lcsgame/code/trunk", revision: "738"
  version "4.07.4b"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/lcsgame/code/trunk"

  # This formula is using an unstable trunk version and we can't reliably
  # identify new versions in this case, so we skip it unless/until it's updated
  # to use a stable version in the future.
  livecheck do
    skip "Formula uses an unstable trunk version"
  end

  bottle do
    sha256 arm64_monterey: "fe4700d7dbd9901cd46e1fdd19453b308d918391914bac529059b25f229b7bc9"
    sha256 arm64_big_sur:  "1ec069485376de05c00be777102bcef25f3f1349d84ecfc2e53990d6c6e403dd"
    sha256 monterey:       "a90a57e3001f38f79b787bbaad00e38099fcac09da06780f2996ae0666d80420"
    sha256 big_sur:        "9e3c6957bab58eaf828f8420fd7e493bb352544ec552c96eb24c8d1ec8d4adc6"
    sha256 catalina:       "65391613e5fd3ea3d8e5f7a2d5586105e3408bb09cddb77aebcfd4bcb7e3396a"
    sha256 mojave:         "91469578607a9f4d1ae989ee523f2b5dd97c976d32d9a822769129df828163e5"
    sha256 high_sierra:    "5b640b7b87dfe6603670addce1b6af77b0cd7ebbda10c445fddc6d365960e761"
    sha256 sierra:         "a8fa614ec5adc3ee2d7417a024bf5e9c78e9f8d4e043e0b916dc5a99f1bb1d9c"
    sha256 el_capitan:     "621487b12c93a9b37e1330041f979a28d3d310c1d8c9efecf274808d081d510e"
    sha256 yosemite:       "9ca23650e17e177c4c9fa5352dc81a9f415bc3778b2fd8a55330936eb4d7d28c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./bootstrap"
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make", "install"
  end
end
