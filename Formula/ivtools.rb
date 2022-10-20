class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 4

  bottle do
    sha256 arm64_monterey: "cabbddd0dec900222bca2f3ec571c72be68520762436ebe34ea6fb7c83cd1296"
    sha256 arm64_big_sur:  "035e0a866d2f6a99aefaf35669cfcbdd183d1fe227cc6e2cd8b5e9339294ace7"
    sha256 monterey:       "7bbbfafc034b5ca5552353641635411d6ce7bea1caa268ff92b068f1f8f16381"
    sha256 big_sur:        "86802e7820e92b829ed8de9faf6cee51ba917fa407224578844525781cc76ca9"
    sha256 catalina:       "dd1a98ea161e6c5a93b80adccbcce1f8368e47c0838217189545e10365d993f7"
    sha256 x86_64_linux:   "94016d222bb9b16d32d78916652096776cd06cb46a72fe451ca4cd0588f84f49"
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
