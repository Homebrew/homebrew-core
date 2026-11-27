class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-2.3.1.tar.bz2"
  sha256 "2bf94e0e677e5a8fc31f79dd323f91c5416b36fb851058bc1e8bce39f2642434"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "50fa5f17d713f46f868a7d8de64f2057a5c868a5dc102c47dd59db582f080666"
    sha256               arm64_golden_gate: "63197bb323b8c5ab478aefcfbf0ace1a20bdc8080f270e610852e646824ca811"
    sha256               arm64_tahoe:       "28fdf2ec352e6caa7c5c9e142eb2d1636a3fee34c1cd8e78ac58ab5eb4581b10"
    sha256               arm64_sequoia:     "a16ad13f866957188976f1fad13ab544f7f7f27118f4450996102840e3e2d0de"
    sha256 cellar: :any, arm64_linux:       "551b3f0766dfc104afa5d6037513832f292b1d7c38b2541feec5cbb4765a4df5"
    sha256 cellar: :any, x86_64_linux:      "4fffc6a234ef19ad28064c98579a811b4c7d62eec656227594043e55e7efc737"
  end

  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  deny_network_access!

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
