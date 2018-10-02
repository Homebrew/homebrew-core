class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v5.0.2",
      :revision => "0c633c27eaeab2a9d30efb01199579896ccf63c9"
  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    rebuild 1
    sha256 "1398f956766797a114160ee7cbdacab54caac3f0a64871a8bc47385b067682e7" => :mojave
    sha256 "de52e9169d747dadc908bccae5484a9c08ec0565ec712c0a5546581faa3683be" => :high_sierra
    sha256 "ed7bc7d8bb37a50a44f0de2f9567c27b2aa246edd1d73d843399509a4046665a" => :sierra
    sha256 "dc351b9774df4854446ad8cabc1222871d3074b2240a2cbef5e96acfd5bd67ed" => :el_capitan
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
  depends_on "openssl"

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
