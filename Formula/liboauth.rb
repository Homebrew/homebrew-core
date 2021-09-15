class Liboauth < Formula
  desc "C library for the OAuth Core RFC 5849 standard"
  homepage "https://liboauth.sourceforge.io"
  url "https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz"
  sha256 "0df60157b052f0e774ade8a8bac59d6e8d4b464058cc55f9208d72e41156811f"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e843a7ac1cf285dfadcb2ebe515dc842d73a3035aa7ceede90b940d4036459ac"
    sha256 cellar: :any,                 big_sur:       "2a735e19305674c11fbf4aeae054f84fa9c50d4aed69aa757a818c8f27da0e7e"
    sha256 cellar: :any,                 catalina:      "1ce26c143029edc957263b3f7c64449c385a5b016e7adbfb1bf40018df08a319"
    sha256 cellar: :any,                 mojave:        "2cc45826629d726ad5496c7d1ead73844d213f0862c981830645751ff0f678be"
    sha256 cellar: :any,                 high_sierra:   "c1f049ca62762088244421339f848a5de1e5e388ced1d15463da00a9b0222784"
    sha256 cellar: :any,                 sierra:        "d3a3ffc611c1d2047e2b56a632e7d4b4e5f4d0657483932fdcd4972455d28f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4b6121635263809e6c2294ac2852c0e8a2680cdcc0fec733e01bc83da7ac6a"
  end

  depends_on "openssl@1.1"

  # Patch for compatibility with OpenSSL 1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/121e6c77a8e6b9532ce6e45c8dd8dbf38ca4f97d/net/liboauth/files/patch-src_hash.c"
    sha256 "a7b0295dab65b5fb8a5d2a9bbc3d7596b1b58b419bd101cdb14f79aa5cc78aea"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make", "install"
  end
end
