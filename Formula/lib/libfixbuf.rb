class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.4.2.tar.gz"
  sha256 "4286d94224a2d9e21937b50a87ee1e204768f30fd193f48f381a63743944bf08"
  license "LGPL-3.0-only"
  revision 1

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f54f4b9ab50951378465a2cd82ba0a971776795023eb4262366823b687462844"
    sha256 arm64_ventura:  "3628545ce856533c4af4c63d284fda709c5b437c7fa24ca23700f5808d2169e0"
    sha256 arm64_monterey: "2a925e71b750fa5ecfc86481c6da0083ca2f64c60c434ca99ee4d8d94b8ad4e4"
    sha256 arm64_big_sur:  "1d5bb5c711ce515a66f428dc0735f22cd69bb88ddc1b170f887463db4f951ac3"
    sha256 sonoma:         "58a348b2b939faecd560b879a62ac8b17a9cc6c0500163b4d5d5fc7b8bc76fa6"
    sha256 ventura:        "8cf8b472510703c3a8c3b162abb0e84dee9f925827b68713c24a6b1c98f99447"
    sha256 monterey:       "445a73cc3b0ac3aa4af0bb51fafb9b0aa82173d507f78dbbf0e639faebadbdd5"
    sha256 big_sur:        "e06f4796f22fa77ac240142257b2d465841709d8ea8b26f8763d6f38b8fb2d03"
    sha256 x86_64_linux:   "51ff5b3d41c6d43607e2f6a10eb3a2b3d02738d72097a3fd85c71166717a72de"
  end

  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
