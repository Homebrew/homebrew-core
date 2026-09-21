class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-2.2.0.tar.bz2"
  sha256 "7160e80e84dafd00d956c84891c533bb7ab16a6a54fbe1574b2f3acf0496977b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_golden_gate: "a4c932fc348a7662f4d740342b51a714ad6e62309247f2e5916238db9875339c"
    sha256               arm64_tahoe:       "c9e850e7f6254e826ea76b15d02825fe712cebad5ed54505ffea7feab5da12c3"
    sha256               arm64_sequoia:     "1b998805d11e6020682577dd8b817e7ff771bac1d6e289c142f8b079308475b4"
    sha256               arm64_sonoma:      "668db25027a3ce2fe6d755086fc8ee60cf33649fa68cbc86bc40e00efd528722"
    sha256 cellar: :any, arm64_linux:       "9a3d9fad56efbfb22e2e6cf337282b7951dfd97237953e3e6fb5e2263ec99151"
    sha256 cellar: :any, x86_64_linux:      "50b32ff4b366cb33d66508f530a1609e38bd0cbc66cf7cdbe2398d79658d6c18"
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
      s.gsub! Formula["libassuan"].prefix.realpath, formula_opt_prefix("libassuan")
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
