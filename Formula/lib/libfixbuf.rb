class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.5.4.tar.gz"
  sha256 "106b8e1e560928a4dc91d8264326bd2463767570d77417535964f450de1f972e"
  license "LGPL-3.0-only"
  compatibility_version 1

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "06a5af7406b391531dbba99e4b0459c9b6577108f4d0eed1a8f2af8e344af234"
    sha256 cellar: :any, arm64_tahoe:       "882ab760594b41aa9201adb97609adadbc5687b18e99e1c515aa6ec3d14ee224"
    sha256 cellar: :any, arm64_sequoia:     "55fd6d658098efbc3bedd78c1d308e08a25217ce572bfdb3ea35a74b08ffad42"
    sha256 cellar: :any, arm64_linux:       "e0922aac6dddc9a1e5b9bfe77e05c151dc785de184a439d171e15c6e4e0c5ad5"
    sha256 cellar: :any, x86_64_linux:      "5faf63faafa693d0e2f5f0b447033b0aa08241539bd245f39f4e69b0047fc3d0"
  end

  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "openssl@4"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    system "./configure", "--with-openssl=#{formula_opt_lib("openssl@4")}/pkgconfig",
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
