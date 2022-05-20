class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 1

  bottle do
    sha256 monterey:     "7fbbcc675ed967dd4039ea4c6627ab5fcbd28dcd9285d4cbe02378342fc19325"
    sha256 big_sur:      "796ce0db5e8e6b284b6d9f5c88fe5f0b526d4d99dd2b8bacdad982a289fc2fc8"
    sha256 catalina:     "a09924498ce0017c4994551cb2f552b4be48db7820ff9794fce4e360f05d1d71"
    sha256 x86_64_linux: "e2138a39b4536b7ea80b147df055e4d42bd4d98f9e574042d262357f07c30677"
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
