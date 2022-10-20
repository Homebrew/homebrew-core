class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.9.tar.gz"
  sha256 "f25e1c35f3d0f1b5a99cc31ecc2353ca83ed46a15163842fba870127dc9c8206"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "247f80609bc18e42e708a1ed4a3009450b3eeac788fe56bae0bb1a95fb220545"
    sha256 arm64_big_sur:  "c10f92144bc24391fa7b0c35cc3ef2cea428c7feba13a6d66ac9a46b1f67b874"
    sha256 monterey:       "e5ea92942763199ad1e53b7ebf95418466ff707e851e10914c2ed9a490e2f950"
    sha256 big_sur:        "961dddefca891df95335bffcca5e6bdc7c6e906ea6ecf77f48be8fa14d833a6d"
    sha256 catalina:       "5d14764fbabda846afaf0ea7d7cd662aaadded927ff71961367a7ca139bbcefa"
    sha256 x86_64_linux:   "98b8c41ab586aa9ffbe28356dc3da20251d58925fcdac865fa90edae7e158dba"
  end

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
