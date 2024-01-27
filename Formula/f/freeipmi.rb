class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.13.tar.gz"
  sha256 "196e33706174767a6d7ee2b9c451075cd48ba99f27bb83c4f2c511e0c92c74f5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "609a79c0553461a36f2ac0a57fcae29e14142133cde0a7e8088c013902fc11e3"
    sha256 arm64_ventura:  "8583260c6e5706eaf7c94372a1b03d8491fb52669b153ba60bd1a11df5edb61f"
    sha256 arm64_monterey: "fae01f9999f4cc95527066f13b8c4447a5d6e703bc986fbd512069ef3111ffb6"
    sha256 arm64_big_sur:  "8308830e5d4c33dc7d403285ec97545878cce100d122d6b4fa20aa7641eb839e"
    sha256 sonoma:         "5f99c414f633b2906d9f30fae5be6d752dbec2c7d8d2d6398803b90d038f2b46"
    sha256 ventura:        "09f1d39558a5b8e602cab29926918522d88724471892bcd190e57806e92ec377"
    sha256 monterey:       "4001216e0fe3a051849feddbf0dc1ff908919fa240344794576988bbd0e3ebae"
    sha256 big_sur:        "eb31c3a6c89b3666c4eeee2e6fde67b9715febef14441fba601319c4b0f30b5f"
    sha256 x86_64_linux:   "b5764abf88b9dcc6f4a2dd253d49ad46bb74c1065ae41e92b61bde93fa0e79ea"
  end

  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  on_macos do
    depends_on "argp-standalone"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in",
      "$(CPP_FOR_BUILD) -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre $@",
      "#{ENV.cxx} -E -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
