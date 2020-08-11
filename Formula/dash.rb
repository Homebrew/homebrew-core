class Dash < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  license "BSD-3-Clause"

  stable do
    url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.11.1.tar.gz"
    sha256 "73c881f146e329ac54962766760fd62cb8bdff376cd6c2f5772eecc1570e1611"

    # Fix compilation on MacOS
    # See https://www.mail-archive.com/dash@vger.kernel.org/msg01963.html thread
    # and https://www.mail-archive.com/dash@vger.kernel.org/msg01966.html thread
    #
    # Should be remove on the next release (along with autoconf and automake dependencies for stable)
    patch do
      url "https://raw.githubusercontent.com/NixOS/nixpkgs/3020abe5b591d201cc6b760f3a9c6e4b94cfca2d/pkgs/shells/dash/0001-fix-dirent64-et-al-on-darwin.patch"
      sha256 "4295bf45f85b8b738e488a8d3d9e91e2a70a4c5464a74f5e7fc47badd9406c13"
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "21446fdece550bbaa24c64db4f03cba0c41a6b46eaaa20101573026a7f57f96c" => :catalina
    sha256 "aa6941a564fca697da6eb30e3691a8fa354de093d05ee84bbbc50c8045a55f66" => :mojave
    sha256 "49ebe51a7662187224ab620aa50b0473b11c1f88372f7c17da328559d895f5e0" => :high_sierra
    sha256 "4c7ca79c9b006065cb9bba57190103c518791b5a7ea078bb1f960e6f6c9dd7e9" => :sierra
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
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dash", "-c", "echo Hello!"
  end
end
