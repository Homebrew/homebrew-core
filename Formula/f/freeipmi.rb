class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.14.tar.gz"
  sha256 "1a3dac5c76b7ccc4d4f86aa12b8ef9b212baef7489bf05e899b89abb7e14edb5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "c7b6059c94b4f7ff4ab7fab5087dc2e38a85bac93bed5585971984e64c4615ac"
    sha256 arm64_sonoma:   "21b95705b044601921f5af96f9afb8c0fcb4ce6bcf0097a634532a4dde1f8079"
    sha256 arm64_ventura:  "da196e655271b9882ba03f3d8c01dc2fe92ef6c6c8e11639843c20160c96d834"
    sha256 arm64_monterey: "412e0b5e5af95ace23a2ec53cf12d63ca2d37d8a1530aaac6e7559149c33ae2b"
    sha256 sonoma:         "a761d8d0aff35b9251cb247888adcb53b05eada0fa7b94b9dd32dc7aa8750f68"
    sha256 ventura:        "33a0544c632284b4d709a18f32787d500aa531fae071422d92cd2a7d0638b955"
    sha256 monterey:       "8e3c0419e2bd683d2da524f4b3e1afb62489c4395a502eb03d7ea11ed144f51a"
    sha256 x86_64_linux:   "5edacef806046aedd7972e5995f5e0034ff8aea645a7a1410af9142c8f716061"
  end

  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  on_macos do
    depends_on "argp-standalone"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I. -I$(top_srcdir)/man $@.pre $@",
      "#{ENV.cxx} -E -nostdinc -w -C -P -I. -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
