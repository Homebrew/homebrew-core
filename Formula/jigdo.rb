# Jigdo is dead upstream. It consists of two components: Jigdo, a GTK+ using GUI,
# which is LONG dead and completely unfunctional, and jigdo-lite, a command-line
# tool that has been on life support and still works. Only build the CLI tool.
class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "http://atterer.org/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  revision 4

  bottle do
    cellar :any
    sha256 "2f3d7e4982c237ca7f1f6974affd0a9ead3968cce95b2ddfa8e524d8f3f2a148" => :sierra
    sha256 "c358bb19d92627d98ae5343eb2ba9254403dfa6d8a27ba4c0c63bb48944f8328" => :el_capitan
    sha256 "5f7e5d7e53d3c3c3db5ebd6c14fb6c13e1392aaf1d24259a4937640bc291be85" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "wget" => :recommended
  depends_on "berkeley-db"

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
