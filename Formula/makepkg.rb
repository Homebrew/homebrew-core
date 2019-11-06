class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag      => "v5.0.2",
      :revision => "0c633c27eaeab2a9d30efb01199579896ccf63c9"
  revision 1
  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "d57aacac971c91dc50c67e1549ace86763107a3dd2f29f3053f6b4517ef1097e" => :catalina
    sha256 "d6609f75988babfe82d73c7dd85874092fcacfd24fae84bf6bfdec8262ab4279" => :mojave
    sha256 "b8c32c0be56ad6c19d8838c7f27aff105ccd03602bd9357206724efdc6f0c270" => :high_sierra
    sha256 "70ffabbc97bdd9dc1567bd18c7c39151870717835988e3d3fb4ffa7f46c564ca" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "gettext"
  depends_on "libarchive"
  # libalpm now calls fstatat, which is only available for >= 10.10
  # Regression due to https://git.archlinux.org/pacman.git/commit/?id=16718a21
  # Reported 19 Jun 2016: https://bugs.archlinux.org/task/49771
  depends_on :macos => :yosemite
  depends_on "openssl@1.1"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    (testpath/"PKGBUILD").write <<~EOS
      source=(https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/androidnetworktester/10kb.txt)
      pkgrel=0
      pkgver=0
    EOS
    assert_match "md5sums=('e232a2683c0", pipe_output("#{bin}/makepkg -dg 2>&1")
  end
end
