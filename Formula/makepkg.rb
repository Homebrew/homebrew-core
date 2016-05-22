class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v5.0.1",
      :revision => "f38de43eb68f1d9c577b4378310640c1eaa93338"

  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "c7e03081bbffdbb982e85d7bb737adaa3a0d068a95564c026af5749b0389ca4b" => :el_capitan
    sha256 "d2230e87184cdf11947f22aa9beaf588e4682fccfd964d2449b20213630fa129" => :yosemite
    sha256 "3a5020efac5c5f9b7d4a74d950b8bcc5054a50f89b5049e711ec3aaee2c3bfe9" => :mavericks
    sha256 "17dcf87394cd744c514133ddeff9de701082bb2563b70aa4f8820f6116f7938e" => :mountain_lion
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "asciidoc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "openssl"
  depends_on "gpgme" => :optional

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"

    system "make", "install"
  end

  test do
    (testpath/"PKGBUILD").write <<-EOS.undent
      source=(https://androidnetworktester.googlecode.com/files/10kb.txt)
      pkgver=2.1
      pkgrel=1
    EOS
    system "#{bin}/makepkg", "-dg"
  end
end
