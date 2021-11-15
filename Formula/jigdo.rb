# Jigdo is dead upstream. It consists of two components: Jigdo, a GTK+ using GUI,
# which is LONG dead and completely unfunctional, and jigdo-lite, a command-line
# tool that has been on life support and still works. Only build the CLI tool.
class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "http://atterer.org/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  revision 6

  bottle do
    sha256 arm64_monterey: "2c59f74d01a6edcfbcf506eba52abfbfb869f8660a4b16c4b629a3f0bf65df53"
    sha256 arm64_big_sur:  "4a3da913acb523ae926b6ca674548b5cce5a833dd04bc0fa6ab113747f9384e5"
    sha256 monterey:       "771b24886e5e8826e84c733452c0577a511948dced79c32ba3abc0d89fcda01e"
    sha256 big_sur:        "4c2caa44c57e78c0ad0b41116add04c6f7ad34ca10a7a8cfaefb4abf336a0035"
    sha256 catalina:       "bcde67883304312dcb904e44b17928a16ec9cb1c8a469e37b2832104178eb7b1"
    sha256 mojave:         "eb44dc4044f003304fa8dcbf29a607b79e82e62ed1f106fb2172d1af30c139a0"
    sha256 high_sierra:    "dd14191d456b799e759d7adad19a1ca25a1791f63188d60db48460f76d4650fd"
    sha256 sierra:         "2a08598075af594b3d31b957f6fdbb6f86d90d3ad542545eaa5ffc6417085600"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "wget"

  # Use MacPorts patch for compilation on 10.9; this software is no longer developed.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e101570/jigdo/patch-src-compat.hh.diff"
    sha256 "a21aa8bcc5a03a6daf47e0ab4e04f16e611e787a7ada7a6a87c8def738585646"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-x11",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/jigdo-file -v")
  end
end
