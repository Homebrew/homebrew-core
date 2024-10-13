class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-2.5.0.tar.gz"
  sha256 "f985827d543f4f8802d12740f576d232aef1a364bcc9d85ad0ca3fe9142c6ead"
  license "LGPL-3.0-only"

  # NOTE: This should be updated to check the main `/fixbuf/download.html`
  # page when it links to a stable version again in the future.
  livecheck do
    url "https://tools.netsa.cert.org/fixbuf2/download.html"
    regex(/["'][^"']*?libfixbuf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "de8ec946c4b02f477430189347b3c8b14367ac470f5e94dcb8ee68e0ef0ecd6d"
    sha256 cellar: :any,                 arm64_sonoma:   "518869515bf5258d7fa1fbc4d5235ef2fcad2aa7eb54fdff01e2289ebb95c528"
    sha256 cellar: :any,                 arm64_ventura:  "3b2990b0c53315f72e45461f9c2bcf5eec08ce9a8f371f5a0889661ee4b71235"
    sha256 cellar: :any,                 arm64_monterey: "7a1dcbcf8d8d5023d69d7557cbf71de42fa7097a43f0e40992daf89960650670"
    sha256 cellar: :any,                 sonoma:         "9579de64f32cfee3768108e137e39a5e024eede7e72aadad97236e8acbc07eb3"
    sha256 cellar: :any,                 ventura:        "448c2587bfa6fe93bc09fd27002a4efa8eaa7f402bfce7aba40ec70c0c16c02b"
    sha256 cellar: :any,                 monterey:       "34c5b4ec70085244ffd8273af2ba5f08f94856fb7eb7c17e672ad2a0e4c27734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c6294855ef75ae5b347c818c9caf938640f7dc128a52fca9db6ed7b079c71b"
  end

  depends_on "pkg-config" => [:build, :test]

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
    (testpath/"test.c").write <<~EOS
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
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs libfixbuf").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
