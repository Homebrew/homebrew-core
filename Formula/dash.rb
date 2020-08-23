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
    sha256 "17db29bb810402ff59bcd6d0f2ef1075b5d2d40e3ecf5667922c366d82797163" => :catalina
    sha256 "166f69be4147a52713aaf636d1a90057bc0e4ef7764c478dfdf062ae249f8d70" => :mojave
    sha256 "b8b2b9636d2cbc920180dae89e32b37b48cf915ef53136cc0be8d7d8b5764a38" => :high_sierra
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
