class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.5.3.tar.gz"
  sha256 "a87a7527634571cbe5fcf092b5dec9f6d6f93be6b776f16bca2d2412d42e6ac2"
  license "LGPL-3.0-only"

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2efd2fc55aaf6c1fa9f549bbc766bd882001e24ecc1fd49c67898e0b5f08299"
    sha256 cellar: :any,                 arm64_sequoia: "38d9ee575ec8e7fd9be0c845d50ef7356eaf6e2a6e52f8767dfd8ba316dadf24"
    sha256 cellar: :any,                 arm64_sonoma:  "90ad12f18cdf5917337d390fc2f1c827630c3a176faa41db46180d43eb99986c"
    sha256 cellar: :any,                 sonoma:        "2cf5c4aebe2039cde223b64d20448d9d6342e34986e3134b7b2337d4afcefb85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "513ccaf4b9d4e98fd1dbc9126634dd32d14ca1733d8299dbc83f9c75857aca0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a602fe11207dfa0d9bccf12fadd8db0430fbbff1c0a9e29e43f8a49ef3ab276c"
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
