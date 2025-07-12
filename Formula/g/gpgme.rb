class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-2.0.0.tar.bz2"
  sha256 "ddf161d3c41ff6a3fcbaf4be6c6e305ca4ef1cc3f1ecdfce0c8c2a167c0cc36d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256                               arm64_sequoia: "2c66995cde33a82fe56ec3a9310e8510cbf222da60b2a4602ee3fc64c6f93b8f"
    sha256                               arm64_sonoma:  "f7fbaccad97dba68beba223f6968fbd0ad5414a4cb67743eaf11ee1cb7ed394f"
    sha256                               arm64_ventura: "735a2f620ddc067d162045dbd56f0dda6f34494ee8fc2c6d79db5cb035fb9955"
    sha256 cellar: :any,                 sonoma:        "9d7d49aec57a889c8505ab5d4fd5a42604b244f671432e88dbb5eedbfa6cd2a0"
    sha256 cellar: :any,                 ventura:       "ce54ced3aba72951eafcb9cda15e1a5fb98a5fd4969f5f180bbabe9e312c1e0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cfb6e3fddc6cb22702693c3e5c63dea2adeac6da18ba8796459081d67691ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb901798817b1ffebf06359bcf72f1fd4cc31d8f008b8ff8ae79d015823058f9"
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
