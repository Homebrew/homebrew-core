class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.tar.gz"
  sha256 "6a5a55883399cbfef317d8bbf553e57e54945188666b344d9efa98ba3edb57ad"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "4483b8a9d1b66a15b3d498771c68d6ba6ef39724d4d094da29b484115434f02b"
    sha256 arm64_monterey: "6194cd9234844e6c43b54b0ea4a74b02406ac567bee9ba66de8c522e6a1ea544"
    sha256 arm64_big_sur:  "cb3a1430296837d88716f7ecdbbf69aeb4b81564471e55a911739a5d24a03334"
    sha256 ventura:        "85f1eccdceb4c8357f2f2224a6c2cb98980a3d9e6e7ff39950286188d811e1db"
    sha256 monterey:       "385a2a5fa4336a9c0db3b463ccdc308a52d6ec0b6576d3600778dcb6cacafa8f"
    sha256 big_sur:        "8bc6948e8d297c247fb66e31d11293b6c05b5a428bbbbe40b26e18556d125b4f"
    sha256 x86_64_linux:   "0feb38759b3dc540c480a566dfa409a4b42007ada74559380d0b97d94888b7bd"
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
