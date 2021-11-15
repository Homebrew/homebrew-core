class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.27/pkcs11-helper-1.27.0.tar.bz2"
  sha256 "653730f0c561bbf5941754c0783976113589b2dc64a0661c908dc878bfa4e58b"
  license any_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  head "https://github.com/OpenSC/pkcs11-helper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "400fcc51aa64cff0488cf67473f4854360dbd148ce7c00aa0c6d7ab48b60d473"
    sha256 cellar: :any,                 arm64_big_sur:  "79eaec51f13a0bda941703a652f790a2306233428878fd9c2beaca7fcbdb9422"
    sha256 cellar: :any,                 monterey:       "81f13fb6bdc7b87d4c942b76b627e57a1dcc15ef78e77451c85ed23db5f4fa39"
    sha256 cellar: :any,                 big_sur:        "84c49ac08cc1c9f222742d7aa3bd628b32673d2376efbe7059fc8d355ff540ad"
    sha256 cellar: :any,                 catalina:       "5cdee7e99d40242d5026b2fbb448f7390e272bb610f8f7a125ab599941c73a06"
    sha256 cellar: :any,                 mojave:         "3bc3ca9909c0cc67a51ab579ed498dbc9c9dc2842d572b5adc4c715405f78ada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6887bf48e4dcb35860dcc487b8ed57f883f2c5ff8c06722ac43b006be529b73c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <pkcs11-helper-1.0/pkcs11h-core.h>

      int main() {
        printf("Version: %08x", pkcs11h_getVersion ());
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}",
                   "-lpkcs11-helper", "-o", "test"
    system "./test"
  end
end
