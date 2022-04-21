class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.29.0/pkcs11-helper-1.29.0.tar.bz2"
  sha256 "996846a3c8395e03d8c0515111dc84d82e6e3648d44ba28cb2dbbbca2d4db7d6"
  license any_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  head "https://github.com/OpenSC/pkcs11-helper.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "97f9d183777dc541c1280c91c473d0263a0581957255ef0ce7e85ec734249b2a"
    sha256 cellar: :any,                 arm64_big_sur:  "87eff3df3d5e443c1d219878de3b0ef64bfb33df76230309723772361f89a1d4"
    sha256 cellar: :any,                 monterey:       "2a403dbd8fc321a834fec147e9e311746084c144d1360ba23c73b5bb687c4c55"
    sha256 cellar: :any,                 big_sur:        "ba468f9cf80a8df0e4cdd9c5e1ed51dcc32a3b7385e6e66161448a1677067e9e"
    sha256 cellar: :any,                 catalina:       "6e66fe50adb867beca5a8cbc4d79584b6f291f086adddefd71b887bb56f25985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b612cacb26cfda5f4c28ec4e852b2ea91f612f1a45db62debedc987c341d3a11"
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
