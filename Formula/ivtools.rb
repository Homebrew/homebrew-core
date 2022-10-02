class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 4

  bottle do
    sha256 arm64_monterey: "40db7bc09d425c12941d92a954fb92cb941f81dd4d6c7e2e0c694900b81be890"
    sha256 arm64_big_sur:  "2dc4153f46ca419b72ab6377cae709c8c6360484015769827a93d6ffdaea412e"
    sha256 monterey:       "d3acdd3176f1b195905e6cd5b9648a0352b5a479609ada0706cd85ebdcda14eb"
    sha256 big_sur:        "8e23a734d423dbc0c99d434f6f3f7299759576e08af590bb2cef250e36662d33"
    sha256 catalina:       "47e6dafddade7c22ee0912f875c32938bf23e6c24234c628cb3debd04a81f7b0"
    sha256 x86_64_linux:   "e5effaf502f0d65466da9ad27c03e719d13f31c5d388c315edbc293baaecb454"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  def install
    cp "Makefile.orig", "Makefile"
    ace = Formula["ace"]
    args = %W[--mandir=#{man} --with-ace=#{ace.opt_include} --with-ace-libs=#{ace.opt_lib}]
    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Conflicts with dialog
    mv man3/"Dialog.3", man3/"Dialog_ivtools.3"

    # Delete unneeded symlink to libACE on Linux which conflicts with ace.
    rm lib/"libACE.so" unless OS.mac?
  end

  test do
    system "#{bin}/comterp", "exit(0)"
  end
end
