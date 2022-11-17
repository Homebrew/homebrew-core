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
    sha256 cellar: :any,                 arm64_ventura:  "57529ea37fd6a79a28c02ff0fe484412fb6244bded38a2dcff03cef63a4d82fc"
    sha256 cellar: :any,                 arm64_monterey: "02155c6d56975a3cb96cdd5b2e57e993b5841300af1636fd0d8ae5b8e9fae33d"
    sha256 cellar: :any,                 arm64_big_sur:  "2fe182fd00dd0baca77ff94f26a3648a2afbfb3c2ffe7f57b73ece952cacecf0"
    sha256 cellar: :any,                 ventura:        "3e69f78454ee03577960653df8e439972f6c12bbd724053081c8d17d86baf66f"
    sha256 cellar: :any,                 monterey:       "1ae6236ec0c857d5dc1cc2f80c0a50b4d69e8672cf895ce4d53f5c511ea0a511"
    sha256 cellar: :any,                 big_sur:        "caa4474b77fbb8d95e11c77a7d2f4da6ab3b8dec4fe62128e5a72f8572e0a8a8"
    sha256 cellar: :any,                 catalina:       "06f17f7492feabec8b42fa5d2da9f16f4b83526b6f5fa36c251c20a4132db6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b5bcb11b8e1317ef37b1b3e6ba37675ef05fbb7c6f6c314694a9fef3d9c0299"
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
