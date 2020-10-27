class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.26/pkcs11-helper-1.26.0.tar.bz2"
  sha256 "e886ec3ad17667a3694b11a71317c584839562f74b29c609d54c002973b387be"
  # license ["BSD-3-Clause", "GPL-2.0"] - pending https://github.com/Homebrew/brew/pull/7953
  license "BSD-3-Clause"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  livecheck do
    url "https://github.com/OpenSC/pkcs11-helper/releases/latest"
    regex(%r{href=.*?/tag/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "dc52806291729e3481bb2a90cabb9df77f21c30351ed2cc67213caaefed8c667" => :catalina
    sha256 "f2783434ebb595a4e9a9b570c05dcf030a7539d1008e988427e4cd36281b6917" => :mojave
    sha256 "6796ffb18fc1f6c22b800caf32e0e4698c1f82e10529ed6535b634afabf237fe" => :high_sierra
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
