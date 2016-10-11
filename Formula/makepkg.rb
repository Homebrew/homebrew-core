class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://projects.archlinux.org/git/pacman.git",
      :tag => "v5.0.1",
      :revision => "f38de43eb68f1d9c577b4378310640c1eaa93338"
  head "https://projects.archlinux.org/git/pacman.git"

  bottle do
    sha256 "0fabfa371db2dd7b98ec349e6b7a5ba1e8a2413fbef195a1d808829b21a59c4a" => :el_capitan
    sha256 "71b87a9e173cfe65bda64ef6e14be450561aada6f4b337927e6a0d12e9a09ae7" => :yosemite
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
      source=(https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/androidnetworktester/10kb.txt)
      pkgrel=0
      pkgver=0
    EOS
    assert_match "md5sums=('e232a2683c0", pipe_output("#{bin}/makepkg -dg 2>&1")
  end
end
