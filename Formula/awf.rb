class Awf < Formula
  desc "'A Widget Factory' is a theme preview application for gtk2 and gtk3"
  homepage "https://github.com/valr/awf"
  url "https://github.com/valr/awf/archive/v1.3.1.tar.gz"
  sha256 "62a0b02170109c81ffbd4420b9385470d62de6fffa39002795e6992fcb4e36d8"
  head "https://github.com/valr/awf.git"

  bottle do
    cellar :any
    sha256 "83bd923e218967b1699c1c8da083f4faeb5728edaccd90153a6cc7967da58b52" => :sierra
    sha256 "b3e0766ca961866eff9a05232286aaa72499f58f5fbc6faae26eff7806fee6db" => :el_capitan
    sha256 "e1ff5608c33ec93bc4d5f94471b402f35955840b6415200ae85ed44efe3b0f13" => :yosemite
    sha256 "fecbfc52d80eb68b049a40d85f0cdf14c47405dc3335062f5d681ecf4602bcbe" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "gtk+3"

  def install
    inreplace "src/awf.c", "/usr/share/themes", "#{HOMEBREW_PREFIX}/share/themes"
    system "./autogen.sh"
    rm "README.md" # let's not have two copies of README
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert (bin/"awf-gtk2").exist?
    assert (bin/"awf-gtk3").exist?
  end
end
