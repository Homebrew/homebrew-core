class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.tar.gz"
  sha256 "6a5a55883399cbfef317d8bbf553e57e54945188666b344d9efa98ba3edb57ad"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b7832b61ea89442eb47365df80d62c135ab747575829be850b9cc44e25b6679f"
    sha256               arm64_ventura:  "308901dd8cea56dc89e58fefd63dea889dd2ad0cdcfae6309b1030366cf5acdd"
    sha256               arm64_monterey: "915a9016e85be3aa2f8cf5ca803d3b3eff5ec24c6e82bec01000206ed1f11b95"
    sha256 cellar: :any, sonoma:         "8609c55cc742badffacb1d04ce702bf1ba18237dec5d010b8adb736232f6a8bc"
    sha256               ventura:        "37bd9d56364c6fb1de7ff35ac1546b71ea9284d682346fe713d60637f5dac06b"
    sha256               monterey:       "11fe86c640c678230dca2bee5bac746faf5993b27a51ef073e163405b1e89095"
    sha256               x86_64_linux:   "73e14906aa2298300b5f6986d0da662cbe8374f163dafb5f25a85b40414bc9ef"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  # c++17 build patch, upstream PR ref, https://github.com/vectaport/ivtools/pull/22
  patch do
    url "https://github.com/vectaport/ivtools/commit/7ce87b9159e720cf1990b6fef10ba7a8b664bcda.patch?full_index=1"
    sha256 "0c1e722b574df66e3c6d4114b066db99691764a04f92c77af2b7adaabde3782c"
  end

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
