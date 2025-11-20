class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-2.0.1.tar.bz2"
  sha256 "821ab0695c842eab51752a81980c92b0410c7eadd04103f791d5d2a526784966"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "f43aa96d4271d497b8e3c03a48d2e7ae78d9106ea26e1bbb983ee923fa4bb11a"
    sha256                               arm64_sequoia: "623bec9ed07b99b203cc8bac45e5d50f15cad57beaaca0bfe4b6428efd6bb886"
    sha256                               arm64_sonoma:  "1c3ec9f67e39a8897746cd038199366ff78115723ecf11b0bac100eb183387e9"
    sha256 cellar: :any,                 sonoma:        "1e07b763ef12b4f6a76a87b705f52e83d9ae62fe85f762170e2e401d999d436a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94ed67d29ae8433b0b9b8478fdf7323ddd33b5f24c3b56af352774625592cba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9297331ca5752b0a415a3e90aa0af51a7f3185426daf39a55b92250bd6555f0e"
  end

  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-silent-rules",
                          "--enable-static",
                          *std_configure_args
    system "make"
    system "make", "install"

    inreplace bin/"gpgme-config" do |s|
      # avoid triggering mandatory rebuilds of software that hard-codes this path
      s.gsub! prefix, opt_prefix
      # replace libassuan Cellar paths to avoid breakage on libassuan version/revision bumps
      s.gsub! Formula["libassuan"].prefix.realpath, Formula["libassuan"].opt_prefix
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")

    (testpath/"test.c").write <<~C
      #include <gpgme.h>
      #include <locale.h>
      #include <stdio.h>

      void init_gpgme(void) {
        setlocale(LC_ALL, "");
        gpgme_check_version(NULL);
        gpgme_set_locale(NULL, LC_CTYPE, setlocale(LC_CTYPE, NULL));
      }

      int main() {
        init_gpgme();

        gpgme_ctx_t ctx;
        gpgme_error_t err = gpgme_new(&ctx);
        if (err) {
            fprintf(stderr, "gpgme_new error: %s\\n", gpgme_strerror(err));
            return 1;
        }

        printf("GPGME context created!\\n");
        gpgme_release(ctx);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgpgme", "-o", "test"
    system "./test"
  end
end
