class Qdae < Formula
  desc "Quick and Dirty Apricot Emulator"
  homepage "https://www.seasip.info/Unix/QDAE/"
  url "https://www.seasip.info/Unix/QDAE/qdae-0.0.10.tar.gz"
  sha256 "780752c37c9ec68dd0cd08bd6fe288a1028277e10f74ef405ca200770edb5227"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    sha256 arm64_ventura:  "8a65baa3a3b7a91e50b9b6887e944b365e3fb8675aedae3e5496bdd9dec8a8c9"
    sha256 arm64_monterey: "e8bb72388f0c79baa7bc75a5820a3a77a6f61c2466c0b6d0ca0cf06073d4eb71"
    sha256 arm64_big_sur:  "4f51ec56064ae77144a38e80e7bf98cf19399101448f0c5278df2bb292bae59b"
    sha256 ventura:        "c77cebe85e83aa1ee97945035a55c81aef2210653981cc4688a23cbb6ef71bdd"
    sha256 monterey:       "6dc2007e7f4cd389c81fcfccdbaec02b12956133e6250614edf374c8ca5c6ebf"
    sha256 big_sur:        "b2a572238e037b46c2765c32bf92180e1370bd1ba4fae123966d715f2b07f796"
    sha256 catalina:       "9b52e69dfcbeed51cacae5189cd2833da3bafda73ebb155b7d6a3c57eb8152fd"
    sha256 x86_64_linux:   "db3a6068e466987b92397d842c2b3ecde2bded442094c3f913333f128758d0c6"
  end

  deprecate! date: "2022-09-23", because: :unmaintained

  depends_on "sdl12-compat"

  uses_from_macos "libxml2"

  def install
    # Fix build failure with newer glibc:
    # /usr/bin/ld: ../lib/.libs/libdsk.a(drvlinux.o): in function `linux_open':
    # drvlinux.c:(.text+0x168): undefined reference to `major'
    # /usr/bin/ld: ../lib/.libs/libdsk.a(compress.o): in function `comp_open':
    # compress.c:(.text+0x268): undefined reference to `major'
    ENV.append_to_cflags "-include sys/sysmacros.h" if OS.linux?

    ENV.cxx11
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Data files are located in the following directory:
        #{share}/QDAE
    EOS
  end

  test do
    assert_predicate bin/"qdae", :executable?
  end
end
