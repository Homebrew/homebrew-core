class Freeipmi < Formula
  desc "In-band and out-of-band IPMI (v1.5/2.0) software"
  homepage "https://www.gnu.org/software/freeipmi/"
  url "https://ftp.gnu.org/gnu/freeipmi/freeipmi-1.6.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/freeipmi/freeipmi-1.6.8.tar.gz"
  sha256 "4aa46a269ecc1bbff9412451f17b5408f64395e7dc45b713edf5eb5362700a71"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "92acf4bfe30602ff62420cb4b2c6824066553410bf2fd4fae5986f5e28bf178c"
    sha256 arm64_big_sur:  "961064dca3e312d23150cb3b1fee87ef5903a3ea863404b04b90ae6fc3282d9a"
    sha256 monterey:       "ce2d911b60b36dd247441befcc18553e322428c04222be0d4c1166368eb253a2"
    sha256 big_sur:        "94211efde5f73e6eca23983c67514ca977be9ce821e4e6266a95c4423531348d"
    sha256 catalina:       "5b6dd5d1c757fc344be9401e63ee1774658efc1eeb5486171161acafb60a5b89"
    sha256 mojave:         "96bd9a3bde2379bfaf2b88b2de7e0e8c185c93a71f0b9cd864afd1d9d693bb77"
  end

  depends_on "argp-standalone"
  depends_on "libgcrypt"

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
      "clang -E -nostdinc -w -C -P -I$(top_srcdir)/man $@.pre > $@"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system sbin/"ipmi-fru", "--version"
  end
end
