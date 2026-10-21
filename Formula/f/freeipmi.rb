class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.20.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.20.tar.gz"
  sha256 "9cc644530ee629ffb94d6fd209e7cb4a8b8ae6677f89d2dc461efed9b2e709f2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "347bfaa6be50d30ca86a51aaf3b1dd7b5d7e467b8526ca9640b99b8a9a99ecc4"
    sha256 arm64_tahoe:       "df9e2b1b93b118953d354f84b58b6bb4b6171cdab1dc17e9639f2241479e3e7a"
    sha256 arm64_sequoia:     "35ffe138e00f0c9898de00644d3a69308ee163a7e479c45d703e83e7240b9772"
    sha256 arm64_linux:       "0493c24b85ab162f0438af4f24d4e1c970d894e134c96380114c417e633a128d"
    sha256 x86_64_linux:      "4a7e7ac968c87020c61ec7e22de57d99a692e617a11a0b135d201e30e0b13bbb"
  end

  depends_on "texinfo" => :build
  depends_on "libgcrypt"

  on_macos do
    depends_on "argp-standalone"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Hardcode CPP_FOR_BUILD to work around cpp shim issue:
    # https://github.com/Homebrew/brew/issues/5153
    inreplace "man/Makefile.in", "$(CPP_FOR_BUILD)", "#{ENV.cxx} -E"

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
