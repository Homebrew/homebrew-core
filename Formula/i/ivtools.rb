class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.tar.gz"
  sha256 "6a5a55883399cbfef317d8bbf553e57e54945188666b344d9efa98ba3edb57ad"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "8c0c13fec5d7dbb494964ba3e1468c26e75d16d2fd455d067670c7509c757cdb"
    sha256 cellar: :any, arm64_sonoma:   "9aff849b29d9ff8c26c9fa6f2465fed83432940fa92e0bbf02de4ec9f056e537"
    sha256               arm64_ventura:  "983f0e8636e109d5908cb785451ccf63b0c50ca080d8ebcc9479396d92d81989"
    sha256               arm64_monterey: "40498e4bc74223a345b5558cd13a15f201cc68c79aed787d20bf9bbbacf552f9"
    sha256 cellar: :any, sonoma:         "fa6dca449abf1dbf670ca9ef2256f99e843618f923d897767c0629d6671f78e4"
    sha256               ventura:        "40cdf0f8b141813718e9f4d4b7b3a32752f3cac1b5024014fce5e2405b9ed14b"
    sha256               monterey:       "eecf13aa53e64d6b6deb95d05c8e633d1c8ecb5c28bbbc19250a9ce3a7f44483"
    sha256               x86_64_linux:   "1a57b1289fa8c1ea7c42a4f96fd9dfbf4082aa96f23d19ad7942c2cf4af4eeda"
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
    system bin/"comterp", "exit(0)"
  end
end
