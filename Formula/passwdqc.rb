class Passwdqc < Formula
  desc "Password/passphrase strength checking and enforcement toolset"
  homepage "https://www.openwall.com/passwdqc/"
  url "https://www.openwall.com/passwdqc/passwdqc-2.0.2.tar.gz"
  sha256 "ff1f505764c020f6a4484b1e0cc4fdbf2e3f71b522926d90b4709104ca0604ab"
  license "0BSD"

  livecheck do
    url :homepage
    regex(/href=["']?passwdqc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "757aec7ca4e20667bc598f0749679626bcb59a1659733fb8e9caf06c765fa7a5"
    sha256 cellar: :any, arm64_big_sur:  "ed3dc06aa375b5fe7a83f55c5cbdb37deb2e5dea63662fbd00fb5869486821ef"
    sha256 cellar: :any, monterey:       "37d84a6bca02a4901043ff7afb98b6d6ce033c4f4464ab52714a5da0eea81594"
    sha256 cellar: :any, big_sur:        "2aabe92682e07ffa405d348e7d2f263c79f92e1dbb972fec4729a5e7254cc0bc"
    sha256 cellar: :any, catalina:       "2b9fe24f7b39be287229ef32275cc7f6609e3c7fcbb8f53f2180ca1506e880b1"
    sha256 cellar: :any, mojave:         "e5f0c3879c811e178aed95c5541ea0f3b8967865d75a425bc3ac1b102a9b1014"
  end

  def install
    # https://github.com/openwall/passwdqc/issues/15
    inreplace "passwdqc_filter.h", "<endian.h>", "<machine/endian.h>"

    args = %W[
      BINDIR=#{bin}
      CC=#{ENV.cc}
      CONFDIR=#{etc}
      DEVEL_LIBDIR=#{lib}
      INCLUDEDIR=#{include}
      MANDIR=#{man}
      PREFIX=#{prefix}
      SECUREDIR_DARWIN=#{prefix}/pam
      SHARED_LIBDIR=#{lib}
    ]

    system "make", *args
    system "make", "install", *args
  end

  test do
    pipe_output("#{bin}/pwqcheck -1", shell_output("#{bin}/pwqgen"))
  end
end
