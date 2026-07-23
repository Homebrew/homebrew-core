class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftpmirror.gnu.org/gnu/freeipmi/freeipmi-1.6.18.tar.gz"
  mirror "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.18.tar.gz"
  sha256 "8098b23820038ad0aa39abf0f9a012e24683d384d9f91e760acb2a68b465e0fe"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "9d7d6455f4f39dbb2d4ca9e2ba8f0c6f70b154076714af62c7ea27dadfe0d3df"
    sha256 arm64_sequoia: "1489a97fd239243c5470a4354efb84e335c363ab941ee443903f5cafbc9d4c05"
    sha256 arm64_sonoma:  "49fa11c2ed4abd96e3503951433031b657ced44fdb67149a3c6f0f7e350907fa"
    sha256 sonoma:        "f711da760cbb1e6870665764fa23ceb835da106b06e95ca27c27e7dbd42eb956"
    sha256 arm64_linux:   "53f437f835d8607f3f1f123d28a778c2c8271d2fe59c7471cb1160cb9a8056e9"
    sha256 x86_64_linux:  "f72a49b937b18745dda867b623ebed942304f60f5eba7a53c6cb47fa378d6bfb"
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
