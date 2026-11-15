class Libtatsu < Formula
  desc "Library handling the communication with Apple's Tatsu Signing Server (TSS)"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libtatsu/releases/download/1.1.1/libtatsu-1.1.1.tar.bz2"
  sha256 "18f471f131c1d55ccc02fa09565d870030c6ce92f737b89fe1b3849941ebb303"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/libimobiledevice/libtatsu.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b98c6d0a8be78ef52e8960b7d696dff98e45018e54f9551e7a237307b77dce6d"
    sha256 cellar: :any, arm64_tahoe:       "eeb81f1250a7a1da79ea72e6511a37637a1e1bd1d0848ce0fd62819152f5fe3a"
    sha256 cellar: :any, arm64_sequoia:     "5a56f78092905876385d4b32a91fae011e288fb6de414551af905f33ffaa4792"
    sha256 cellar: :any, arm64_linux:       "8734e918eb67b666b3216424a424f2b68d413419b0fbfdc71397005c8ca28b7b"
    sha256 cellar: :any, x86_64_linux:      "a31b28255dfa9d816b95c1a6ce0edd04a00a248cf3d685002a5a55a94041aba2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  uses_from_macos "curl"

  deny_network_access!

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libtatsu/tss.h"

      int main(int argc, char* argv[]) {
        tss_set_debug_level(0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltatsu", "-o", "test"
    system "./test"
  end
end
