class Libtomcrypt < Formula
  desc "Modular and portable cryptographic toolkit"
  homepage "http://www.libtom.net/LibTomCrypt/"
  url "https://github.com/libtom/libtomcrypt/releases/download/1.17/crypt-1.17.tar.bz2"
  mirror "https://distfiles.macports.org/libtomcrypt/crypt-1.17.tar.bz2"
  sha256 "e33b47d77a495091c8703175a25c8228aff043140b2554c08a3c3cd71f79d116"
  revision 1
  head "https://github.com/libtom/libtomcrypt.git"

  bottle do
    cellar :any
    revision 2
    sha256 "ad36e0538d35fe35f71a1c5d7c19945a2800e791911a53bf1168b9bbc6df8db1" => :yosemite
    sha256 "108baa1e0008f5967f5dae0f670558bcb0bd679c94deb2d21d335525beda21ac" => :mavericks
    sha256 "dd8857ae5f03d3e26c9f741b13522f0e868539264ab9c3dceb26f6019fe1996c" => :mountain_lion
  end

  depends_on "libtommath"

  patch do
    url "https://github.com/libtom/libtomcrypt/commit/53f04b8e6b9cee1fbc213433f42d1c9e288cb65e.patch"
    sha256 "f622ed29119c7d181c8f087fb5e427c6bb43b8920dea1fb81d5a69bc51baafa2"
  end
  patch do
    url "https://github.com/libtom/libtomcrypt/commit/62878de0c5dbb9f89474590d953bbdb339bd2f76.patch"
    sha256 "c6f7c62f7f0f20667e170682c0964a07480e7819c00707b4ff207c69ef48f1d3"
  end

  def install
    ENV["DESTDIR"] = prefix
    ENV["EXTRALIBS"] = "-ltommath"
    ENV.append "CFLAGS", "-DLTM_DESC -DUSE_LTM"

    system "make", "library"
    include.install Dir["src/headers/*"]
    lib.install "libtomcrypt.a"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "tomcrypt.h"
      #include <stdio.h>

      int main(void)
      {
        hash_state hash;
        const unsigned char *string = (unsigned char *) "abc";
        unsigned char digest[32];
        unsigned int x;

        sha256_init(&hash);
        sha256_process(&hash, string, strlen((char *) string));
        sha256_done(&hash, digest);

        for (x = 0; x < sizeof(digest); x++)
          printf(\"%02x\", digest[x]);
        printf(\"\\n\");

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-ltomcrypt", "-o", "test"
    assert_match /ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad/, shell_output("./test")
  end
end
