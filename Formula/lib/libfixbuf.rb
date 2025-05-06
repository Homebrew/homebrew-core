class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.5.1.tar.gz"
  sha256 "e75a463855a3d8a6060860f6490e79dee3305e650bbb60111c4dae8e52cbdae7"
  license "LGPL-3.0-only"

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb0844f675d129e9c133bc28bbd5d9b1915b429f5f761094d3ff2db7563df0d6"
    sha256 cellar: :any,                 arm64_sonoma:  "4966c36322bf9c69e915c226185d00499bd66e0499d42700c8079bbe4e9517a1"
    sha256 cellar: :any,                 arm64_ventura: "6f143991654646e12feff3b8cd2f951e1ce21ce42c48b2093f5fb676d22b165e"
    sha256 cellar: :any,                 sonoma:        "d68ce40ce5149760d24d0fb26511ec462d4491b9766dbfcd35afdde6bf365932"
    sha256 cellar: :any,                 ventura:       "dce1cab17bef5b90dad6064628703f5c6d35ec630b2158b8d2dc5f8a347adbe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34bf31cf7ae49ee6cdc4d4fa074d35d68a567cdfa9d89fc7fe958e15eeeca51a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2f2ea84ed0a6cfafd82cca320ae2626d9240b10265318eb26300b5e88ca6df3"
  end

  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <fixbuf/public.h>
      #include <stdio.h>

      int main() {
          fbInfoModel_t *model = fbInfoModelAlloc();
          if (model == NULL) {
              printf("Failed to allocate InfoModel\\n");
              return 1;
          }

          printf("Successfully allocated InfoModel\\n");
          fbInfoModelFree(model);
          return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libfixbuf").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
