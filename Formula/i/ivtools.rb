class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.tar.gz"
  sha256 "6a5a55883399cbfef317d8bbf553e57e54945188666b344d9efa98ba3edb57ad"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "011cc352eb448d2252427469b35d029111a57f591b7aca4dc86f1c5f1f36b5a8"
    sha256               arm64_ventura:  "d0a3958e1dd90e513cd66131c6cfe3d02de7b4f32ccacdbb401f127ef56fab5b"
    sha256               arm64_monterey: "3e5a34dafb34488039b79fc735387a0113249b6322da951c4a159dc20d6c091e"
    sha256 cellar: :any, sonoma:         "43e56dafc21201526afdc1d50cfc6ce50ea52302520587f22abaaa83e691742f"
    sha256               ventura:        "5140fe0ca8a8252921a8f28a4a21481e867b546ab2de894b49d00f1bbef1fdee"
    sha256               monterey:       "f30b5b950c291f4171c385a6baf3346cb857c5ba6e6b07d6d9e59e26a307d044"
    sha256               x86_64_linux:   "143d6f8e98861c196b0f004445e3c210fc52fa79f87fbd8b6c6694a2ac567b11"
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
