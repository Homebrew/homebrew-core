class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.29.0/pkcs11-helper-1.29.0.tar.bz2"
  sha256 "996846a3c8395e03d8c0515111dc84d82e6e3648d44ba28cb2dbbbca2d4db7d6"
  license any_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  head "https://github.com/OpenSC/pkcs11-helper.git", branch: "master"

  livecheck do
    url :stable
    regex(/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9399ed1643dfc08396104a794b71e6151eb8719ad4cae7730b04d8e3433fb476"
    sha256 cellar: :any,                 arm64_ventura:  "704fc17cc0170328b5e772918f3cfe09b32fda1310488e3d1e913791a88fb1c6"
    sha256 cellar: :any,                 arm64_monterey: "a2886c40d21096da330d82d610aa3f2c7613d0f5beb4dc86e1858fa96cd528d7"
    sha256 cellar: :any,                 arm64_big_sur:  "0e40c843a213e6dce17a34462bf59f80b62ea2282c84a7900a818f7c6c56e223"
    sha256 cellar: :any,                 sonoma:         "5866e6e83191e79d9a8a288cace913e3e0f91670af8c238134ba51426d3db6fb"
    sha256 cellar: :any,                 ventura:        "b5a85f9389b60f374499bab678ccfb86fd86a180aa91943a33cb85df75c4c99e"
    sha256 cellar: :any,                 monterey:       "32b5a12ccb7f2b817717b80dd5596f6469599dfa1f0052249f19ba1cc4fe1deb"
    sha256 cellar: :any,                 big_sur:        "7e9e371045bed72b15fb40a09ae168c8f44692d4638b5752aeaa690493e50023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3341c24bfb7728104d23b40045ab0d442fdae7eb4debea1ac7dedce1b2809df6"
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
