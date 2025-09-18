class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.5.2.tar.gz"
  sha256 "76c659f6bc4493c63c0ffdc5ee4fdec891316ae97d75d66ad4080cadd14e2406"
  license "LGPL-3.0-only"

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da79bca1e1e000161c0d53323ef4adabfd1d524e93290f1d0d33aabd5327a059"
    sha256 cellar: :any,                 arm64_sequoia: "90b4eef9e86dc5a7cec530bde1b84af4c35113681eb7bc782aeb2cd4efe05704"
    sha256 cellar: :any,                 arm64_sonoma:  "83cdb4f215d36e49d9444d69b8874d378b396d36cf24e9aba4e906c6a991a291"
    sha256 cellar: :any,                 arm64_ventura: "950f1ff90c9187ef27f52ccd5ed1f192fd59e020b7a6be364dd7d0649c12ca32"
    sha256 cellar: :any,                 sonoma:        "848d38cb2e8e4b209c63bda63ec188cdbb87d73fc69102f8d37c1a6e0caaa95f"
    sha256 cellar: :any,                 ventura:       "a4aca420341021a5cb74c257fb012de0fc4be5622ead98fb15b43560fa3f3dde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b03fd5c38df4da8ff15db6956b053708ee5aada42d199f6f62ec4590f5a9c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abf9e86b356978c3ca20d3af08488af7572c63694e0e07744e96a8e3e52747cb"
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
