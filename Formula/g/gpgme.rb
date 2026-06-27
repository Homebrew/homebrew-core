class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-2.1.1.tar.bz2"
  sha256 "6d7ee12b209d7dce75468db53f72a90e1ad3d21f4c304ef2c002612a52f5333a"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "c69dd342a1debd3dd07c2bfe8ad734a286a4f87bdd092d9b58bc7577e345765e"
    sha256               arm64_sequoia: "e28c699a92b2bfe383a0ba097da58ed799996c88207f7fbcb2cbad2ef27a5ec8"
    sha256               arm64_sonoma:  "fa07f1bb78191ba559c4d84ce73ebd9e52128744c3254a0ef627440f8129489f"
    sha256 cellar: :any, sonoma:        "2378e7c91f90bf82330a4f89095897bec36b5fa613a38ba5cf050101d8080225"
    sha256 cellar: :any, arm64_linux:   "bb6ac68adfb2be92c437885df334edd446bc8905cd62ca9d5c8095f4bf9bd973"
    sha256 cellar: :any, x86_64_linux:  "ac95c5599657e7a938341a868c064c2272bacb03dc60645e47f7bf94c8460993"
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
