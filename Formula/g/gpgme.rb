class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-2.1.2.tar.bz2"
  sha256 "0687a95b299871c4141f507c0f740de6b429c9ac067d0fa4e062e3264df5fb77"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256               arm64_tahoe:   "4d6da3996fea89d8ce84ee6cf115a2b5b151fc9420304945830792c20252aceb"
    sha256               arm64_sequoia: "1046e421c66ef49145a589469fdf34dfba6456ff884af0cb189213e3599c65e5"
    sha256               arm64_sonoma:  "4cbd0b2c4f42f52cf3fe2a7bf74531442fa41f909a18cacbdc5e75725171dea7"
    sha256 cellar: :any, sonoma:        "830725ecf4581f49ec5443ec407ed168232d1e6b49ca98ebaf0b29140306dd41"
    sha256 cellar: :any, arm64_linux:   "a40d7763edf85e29557b501933ca7d4e8487a0471fc5dbfd077b5ad719a388bc"
    sha256 cellar: :any, x86_64_linux:  "c8c0332b1057fa182cd83f026d3f5dfa9fddb1b4c6fa24e56a70fb701ab695eb"
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
