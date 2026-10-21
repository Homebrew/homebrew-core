class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  license any_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  revision 1
  compatibility_version 1
  head "https://github.com/OpenSC/pkcs11-helper.git", branch: "master"

  stable do
    url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.31.0/pkcs11-helper-1.31.0.tar.bz2"
    sha256 "46f0067bccd7be2c28f88b8bca775172b9e52fb6fc1280b44ca8bb831433fef9"

    # Backport support for OpenSSL 4. Using PR commit to avoid conflict from changelog
    patch do
      url "https://github.com/OpenSC/pkcs11-helper/commit/9c64c288384a7676c8e89258738d56f39116bd28.patch?full_index=1"
      sha256 "84421d9689ec9a3f69a92a8606bd2c2de78b5540cd289c5363b322b1eb208316"
      type :backport # https://github.com/OpenSC/pkcs11-helper/commit/59cc22b8d65669da599f1c435fdfe35d4e07db0e
      resolves "https://github.com/OpenSC/pkcs11-helper/pull/77"
    end
  end

  livecheck do
    url :stable
    regex(/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5831ccf7599dce283920c440b34cc86d5e2f121a77c089bba18e77c040b884ea"
    sha256 cellar: :any, arm64_tahoe:       "c9f3dc59eee6baeba82754476d23350f8059e27c131f032c24351519017cf786"
    sha256 cellar: :any, arm64_sequoia:     "2293800c554d9b1dfd43839455e0c89548077a366238813e3c8bca5cb1c3bc85"
    sha256 cellar: :any, arm64_linux:       "40d1774537910c39ed2ee7af16ba07f7f107f908adcd4647dacd8b64c1699ae7"
    sha256 cellar: :any, x86_64_linux:      "632438929bc42615e8b8c6d09205f156cb0fe28e523e12990a2e362068ba3fc3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <pkcs11-helper-1.0/pkcs11h-core.h>

      int main() {
        printf("Version: %08x", pkcs11h_getVersion ());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpkcs11-helper", "-o", "test"
    system "./test"
  end
end
