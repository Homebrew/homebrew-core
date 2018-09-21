# Jigdo is dead upstream. It consists of two components: Jigdo, a GTK+ using GUI,
# which is LONG dead and completely unfunctional, and jigdo-lite, a command-line
# tool that has been on life support and still works. Only build the CLI tool.
class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "http://atterer.org/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  revision 5

  bottle do
    sha256 "85a86018e55a5655fbc0068440dd13427dbc91f3594c4e3da340f16d275c77a3" => :mojave
    sha256 "b85b4bd96c93058b76ae9eefb4351e06646f532742f2990d3181096f305f14fc" => :high_sierra
    sha256 "c9782a26984129d77f041f2c8d9e30735170080ef8951c835196e3303e45d6c3" => :sierra
    sha256 "5b1685bcf35a653a0104f2ca084a55c55729a4c2211b8f18a648b4ef045cc123" => :el_capitan
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
