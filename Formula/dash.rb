class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.10.2.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/dash-0.5.10.2.tar.gz"
  sha256 "3c663919dc5c66ec991da14c7cf7e0be8ad00f3db73986a987c118862b5f6071"

  bottle do
    cellar :any_skip_relocation
    sha256 "16844012602d4d34c4a8bbd4c2aa9eaf4b55f3ace84b2dad9d43635d1385c9e1" => :high_sierra
    sha256 "e0e8ce338b1508655259e85c5eed8185cf9cb39b9ae19c4d148fe81b7d78fe97" => :sierra
    sha256 "e9abd2e67ab2080c39800b02ebe891b524af5f3e5fbe130ac4e6e1df6debf2fc" => :el_capitan
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
