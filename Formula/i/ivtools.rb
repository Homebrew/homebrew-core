class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.tar.gz"
  sha256 "6a5a55883399cbfef317d8bbf553e57e54945188666b344d9efa98ba3edb57ad"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "850f691a328ada79afb06904788bb3ce2b61e4be5809a4816271cf4ad312b772"
    sha256               arm64_ventura:  "a68ca5f6e71d391f33e98e8b2653e469576ce5dac1d1265f6152133391a30226"
    sha256               arm64_monterey: "799484b4aa59e1fe2833ab66a77f6bc1453b32f38736c1bd94d6f0e4784a224c"
    sha256 cellar: :any, sonoma:         "3ed9d3b0f5e1bb69e00e236350e8211954f182d2ac5729be69cd50f0d1125f09"
    sha256               ventura:        "546b61bce064cd0121313a7d3d7219bc49c1f64c997a2934697e73796f5c1036"
    sha256               monterey:       "98571140a0e0244f28e4e9bd2232a051e44571e9484fa6caa7c72c4bb8c88487"
    sha256               x86_64_linux:   "c0afa59d35fefbf575c370bb6ea99133b269a13665f0ea6d2df290d8c3ac00f6"
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
