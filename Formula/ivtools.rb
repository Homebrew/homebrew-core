class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_monterey: "b6803a28f1c090223f625febff95451ea47e8bf952f7462745392867785f1fb0"
    sha256 arm64_big_sur:  "98b40011c921db4d105e265aefb92496abc0488f9bd4a3fec5eac11a2cdfd6c8"
    sha256 monterey:       "57aef06ca71bead6520f0fd99a85ffe8aa50027a499dc3d6d18465b6e40cffbc"
    sha256 big_sur:        "f5f371971fd7656e6c512df1aade186c75d49c25474ff3a84c6996c865cd5370"
    sha256 catalina:       "8168243a6a131eb9d68120062c4ea335b956fe9cf571be4bb7ecc12cc9c9f64b"
    sha256 x86_64_linux:   "f8a6393094c46dbcbf962ab7f3fd577b348eb437885cb6b8c200a80f3dd765f4"
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
