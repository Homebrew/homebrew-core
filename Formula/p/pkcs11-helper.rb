class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.31.0/pkcs11-helper-1.31.0.tar.bz2"
  sha256 "46f0067bccd7be2c28f88b8bca775172b9e52fb6fc1280b44ca8bb831433fef9"
  license any_of: ["BSD-3-Clause", "GPL-2.0-or-later"]
  head "https://github.com/OpenSC/pkcs11-helper.git", branch: "master"

  livecheck do
    url :stable
    regex(/pkcs11-helper[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dacc089490af7c5a5083427ddb8d3bbe72750c0895e9740a3b0c083366bec05d"
    sha256 cellar: :any,                 arm64_sequoia: "14af0cd935c0098c251da028a785ec055fbf1390e49efa7599d64e389bc3317b"
    sha256 cellar: :any,                 arm64_sonoma:  "c971afeedc5f788b1297d152f30a617c0ee94bd0dc07d667ece07f48938436ef"
    sha256 cellar: :any,                 sonoma:        "db89780cd8b197eb8e562f190d5cad113acc337c7689b8103f32c25fd70a3551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4d683661a6a1c128adbdf1eabd49cbbedb2b3e7f3ed2c42883eed6889e9f326"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5567cc0f1a107804f649db18cf383f9fc0fac5927c4aa22d44c8d4b4d5a3edfa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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
