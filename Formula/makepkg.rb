class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v5.0.1",
      :revision => "f38de43eb68f1d9c577b4378310640c1eaa93338"
  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    revision 1
    sha256 "519f7c1d0932fccdfc10884ed069dc96a460e433cf3a31587c5fe602d9e702d6" => :el_capitan
    sha256 "10870ad76b81268069bc2396e36a04a67f887f34de91764921f9261012524fac" => :yosemite
    sha256 "5579c38c1b058128d8c0e2487df32ad6a5c2c32c796dbbd16149e0999d3a502a" => :mavericks
  end

  # libalpm now calls fstatat, which is only available for >= 10.10
  # Regression due to https://git.archlinux.org/pacman.git/commit/?id=16718a21
  # Reported 19 Jun 2016: https://bugs.archlinux.org/task/49771
  depends_on :macos => :yosemite

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "asciidoc" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "gettext"
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
      pkgrel=0
      pkgver=0
    EOS
    assert_match "md5sums=('e232a2683c0", pipe_output("#{bin}/makepkg -dg 2>&1")
  end
end
