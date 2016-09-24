class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.1.tar.gz"
  sha256 "5ecd5bea72a93ed10eb15a1be9951dd51b52e5da1d4a7ae020efd9826b49e659"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8003a2f98535270d82eb36aa45a1fc2252e66242b56df877ca79c678db2b397" => :el_capitan
    sha256 "9073b3c2bcea5a45038b9a13d556e4cc108b09581fbea52accb395f258ae7e4d" => :yosemite
    sha256 "827cff7c7fead9393af80f404eb64d85f70251b0008ea7383e1d72923c1cdc8b" => :mavericks
  end

  head do
    url "https://git.kernel.org/pub/scm/utils/dash/dash.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-libedit",
                          "--disable-dependency-tracking",
                          "--enable-fnmatch",
                          "--enable-glob"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
