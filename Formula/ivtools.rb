class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 5

  bottle do
    sha256 arm64_ventura:  "91a30d469aa420321594566d6c45b77a2aefae12589f59e44ef12600be6659b5"
    sha256 arm64_monterey: "55ed1068532b63920dbf2dbe93d8b42d7c1dcb603823bbd3ae9460cc09c5faff"
    sha256 arm64_big_sur:  "30a2fed7d3eb8d9bd9a6cf9f4d691fc26895906dc0defb721f54fb5159c1d619"
    sha256 monterey:       "85560102f99a1b8371e29f399634d4de3b49598b47184d288d35d8b965fff8c6"
    sha256 big_sur:        "1ba12fcf0b2decec8083cf41bea0d76da84f570c59272785a57586925ab4a8ec"
    sha256 catalina:       "7f9e60f9b03f7c6b65e9a96e9440cae5161e5d85a47043091be51615891f7689"
    sha256 x86_64_linux:   "f4b5e3487cebcc250679bd779c1affd4e948cd3014c7f1ae46e9d0dfbd9288a7"
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
