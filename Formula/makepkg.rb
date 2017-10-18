class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v5.0.2",
      :revision => "0c633c27eaeab2a9d30efb01199579896ccf63c9"
  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "ca90cc4b589587fd656ba11bd2445542a551b8c92c0f472419fb47ac42f01d3e" => :high_sierra
    sha256 "457411b6d7fd00d32cde12826b55a93fbb6d59552215a19d7289550e64d3880a" => :sierra
    sha256 "3052d0fdbd76e5e277f0e463eff423249e9b0c08c126a6d27affa1e5c69335ed" => :el_capitan
    sha256 "64718b5dff7f979eaabd7f9d6aa18d56156bdfbd90f767820f1de6823361d870" => :yosemite
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
    (testpath/"PKGBUILD").write <<~EOS
      source=(https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/androidnetworktester/10kb.txt)
      pkgrel=0
      pkgver=0
    EOS
    assert_match "md5sums=('e232a2683c0", pipe_output("#{bin}/makepkg -dg 2>&1")
  end
end
