class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/gnu/freeipmi/freeipmi-1.6.17.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.17.tar.gz"
  sha256 "16783d10faa28847a795cce0bf86deeaa72b8fbe71d1f0dc1101d13a6b501ec1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "8c9647d3bedfc8a9fc4cd609502036da7a78a087c3ab56b0ab371aa1dd83bb24"
    sha256 arm64_sequoia: "b99597f1175f068d29f4865527e55c6d6dfa491dd2efa788d0362ce3d79efe78"
    sha256 arm64_sonoma:  "e91664b3e01da15001dcc80a597314518a855f5bb2c021175734ae36beafa83e"
    sha256 sonoma:        "5379ce9470e4c8da88a26a8ebdc95d58b9eca974284b1f217464c55db169c305"
    sha256 arm64_linux:   "363a2a4daa1faca593df8ef801fd46d2906df95ea72d580a81eec828079b51e4"
    sha256 x86_64_linux:  "520654b8bdb7cf948034704cc4206f33fc1e70bf82f7d400dba639df4bc9f51e"
  end

  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  on_macos do
    depends_on "argp-standalone"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
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
