class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.tar.gz"
  sha256 "6a5a55883399cbfef317d8bbf553e57e54945188666b344d9efa98ba3edb57ad"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7509e92b7513508704aa54be6b92f5f57890f7c413d20ed03ecbdd6307bb140f"
    sha256               arm64_ventura:  "f15b4a00bb27f6b6ef480beb15cf07076054e599879409354b5c13ca1d1b49a5"
    sha256               arm64_monterey: "6f44556326e4df7ca2daadd1c835c090496782647cc2505697a73fd4080d3d66"
    sha256               arm64_big_sur:  "df3bb35a27ec88a243afd189bb8e4366c23d490e3312046a4c8e2bd3beee88f4"
    sha256 cellar: :any, sonoma:         "3f4a5b6a443badeef88b230c3045b49f7dd223e86a8dcca941294bdde0e8e1a3"
    sha256               ventura:        "a0c20b2a2bbbda73dea23f86dfba32850979feb63217203dfe06abfb25fc7eab"
    sha256               monterey:       "a50ab5e6eef0b90a7a9a0fbe76a3706fa6eec73935a9ea6f3a009608d755df5e"
    sha256               big_sur:        "b8cb965c3d966deed879d6a91ae48301462539b282f9bd06f460e90c52eb1059"
    sha256               x86_64_linux:   "27d69d71ef38b8ad9811cc8310799ec1a14503d83cf04df51dde36ff460e4e5e"
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
