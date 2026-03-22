class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.5.4.tar.gz"
  sha256 "106b8e1e560928a4dc91d8264326bd2463767570d77417535964f450de1f972e"
  license "LGPL-3.0-only"

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2b8afeb4d9ce3d8d2b55f488e3f4df93c85791bb64b32c33fcc1d662eba7e11"
    sha256 cellar: :any,                 arm64_sequoia: "3bfaea10816dbd5dd6c4e51a9755e07bea1929768023f0eec78bb69ca2c24cbf"
    sha256 cellar: :any,                 arm64_sonoma:  "3fa7c6d28c84ffc5300bd79dbb67ddeeecdd572caab22529bdebfb9eb735163c"
    sha256 cellar: :any,                 sonoma:        "64d4455a477ea65a1cc54c6f0633286d42c35da7328e04708a56b45cac3a095c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d339e5ada6c9d514e5d5dd4e757f52673aeb189cc151d29bdce63c48be1e0f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ce88f5bcefb33debbe42fb4c64f5d72488988d59a110ad95c6598a3abfbddb3"
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
