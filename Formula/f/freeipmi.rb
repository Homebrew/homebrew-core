class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.15.tar.gz"
  sha256 "d6929c354639f5ce75b5b1897e8b366eb63625c23e5c4590a7aea034fe2b8caf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "600615952288903808095ab8808b45eae7c2adaa7fdc9d6f4187579fbedd687d"
    sha256 arm64_sonoma:  "e2c6067bcd9b96a9e85b98d14b5e30038a421314c564c953b6c2ae7903434c7c"
    sha256 arm64_ventura: "9f74bd59960c7352c0d63ac4fd4ecddddec57bca1d8ac33518bcebde80a0a5a9"
    sha256 sonoma:        "78711420153a4559ce6a61e5084349b056add23ee61edff9c6d5ed5a77f09df7"
    sha256 ventura:       "2f72ea86838d3b58e9669f04b87e20f494425d863403aecae7cb30d76bf55d00"
    sha256 arm64_linux:   "e9a0013abc5d123bf9cc52a1993b000a28deb2149ca35f198f2618c1506c7be9"
    sha256 x86_64_linux:  "d49402b292786a8ba64707b8985249bbb64c8c5845005dd5efdc2d6c49c4e9e1"
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
