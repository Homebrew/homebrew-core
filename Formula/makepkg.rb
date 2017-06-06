class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v5.0.2",
      :revision => "0c633c27eaeab2a9d30efb01199579896ccf63c9"
  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "d8d4be7d77ef9964f310054ea50a7c577002a4ed79fbeab7b0f76c481851c878" => :sierra
    sha256 "e8e801eb7fd95203b695c1be269ea163a0fd5c964a9bd81d88815417957e117a" => :el_capitan
    sha256 "cb6989f1b3b7f7bf6fbb686d514191d50684345156b4a7ef51633d17fb7e01a5" => :yosemite
  end

  # libalpm now calls fstatat, which is only available for >= 10.10
  # Regression due to https://git.archlinux.org/pacman.git/commit/?id=16718a21
  # Reported 19 Jun 2016: https://bugs.archlinux.org/task/49771
  depends_on :macos => :yosemite

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "gettext"
  depends_on "openssl"
  depends_on "gpgme" => :optional

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
    (testpath/"PKGBUILD").write <<-EOS.undent
      source=(https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/androidnetworktester/10kb.txt)
      pkgrel=0
      pkgver=0
    EOS
    assert_match "md5sums=('e232a2683c0", pipe_output("#{bin}/makepkg -dg 2>&1")
  end
end
