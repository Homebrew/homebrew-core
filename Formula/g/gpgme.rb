class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-2.1.0.tar.bz2"
  sha256 "841c5ea53fc26259f4fbf0e8bde982dea1b8a1ca0cb77e681c82b050566bf92b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "0c10ccfca11d15aa56e4d1256f5937e42a014599476c8bf0fc205f8ccaec4ac8"
    sha256                               arm64_sequoia: "364e7d5a64a11cff1fc174c45ae003edc05710647440d659497093e6e3f852e4"
    sha256                               arm64_sonoma:  "806e6087437443c0f8e0eea337e6d1fd8358085c9d40042a9c3855045fc435e7"
    sha256 cellar: :any,                 sonoma:        "20246e1dabf22226e2cb05d555807e564c89fd05c29ef9e6513ff4dc9ff5d453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c083601bce346a536b7ea6541c4bd50428486ef8c2e71987c7b85938eeca4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cca578994038bbe5e6ec56d04faf8c4f4f272ffbed1808bd574a004213c3037"
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
