class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.9.1.tar.gz"
  sha256 "5ecd5bea72a93ed10eb15a1be9951dd51b52e5da1d4a7ae020efd9826b49e659"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5706775cbe31c1571a6634d36b3ac6383ed4a4e7334772bae9c49f375ed678c" => :sierra
    sha256 "807944242d102a2ab60498cd18377092e4055bbc6a68b950a76b11f013431aa4" => :el_capitan
    sha256 "dd1cccafe8f7a004d396bccf8382e0049aa472be062281cbf75902e2258a91c4" => :yosemite
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
