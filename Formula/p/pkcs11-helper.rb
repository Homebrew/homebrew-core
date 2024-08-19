class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.30.0/pkcs11-helper-1.30.0.tar.bz2"
  sha256 "4c5815ba910cabf26df08d449ca2909daf4538c9899aa7f7fadc61229d3488a9"
  license any_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  head "https://github.com/OpenSC/pkcs11-helper.git", branch: "master"

  livecheck do
    url :stable
    regex(/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d5877e3655d952f137610ab0168b4e996dec23dfc16b1ac4db5ab0cdb46eb525"
    sha256 cellar: :any,                 arm64_ventura:  "720ab7371a01c2ffe4884736240afb22b32c04162a2f5bdf658658556ed7ff74"
    sha256 cellar: :any,                 arm64_monterey: "341be8334102c4305e939ec2b171724076afeb36182cbecc585b84a79de9eb04"
    sha256 cellar: :any,                 sonoma:         "6e3be91e06ad419132aec259d8d7d2700e8672f2011493da0b8635409523fc0e"
    sha256 cellar: :any,                 ventura:        "322d2589c5b33c6ee5ed63b379661701b3bafb3ffb468dc862b33476765448e8"
    sha256 cellar: :any,                 monterey:       "c809e4cf49d88ce528e2469be931667f121cbe243e04bf549da28bbe20c05ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ce66c1a7dcf6725cf1b4f480e734cd4b7ff2f74835b4464c2bf182ce9640d1b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

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
