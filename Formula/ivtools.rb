class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 1

  bottle do
    sha256 big_sur:  "a349834ee1394a4dbf95392aebfe1e89a29fb0f28892296a43b0585c55a15703"
    sha256 catalina: "1d78bb0b1fde4e5487470a26231a0c0ec9f573d5cd91254065ccf1019e7bbc34"
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
  end

  test do
    system "#{bin}/comterp", "exit(0)"
  end
end
