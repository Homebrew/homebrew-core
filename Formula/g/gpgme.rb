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
    sha256                               arm64_tahoe:   "da5c564a9743e2c034a6f7d702337453eec19ead99a25f4efb492cf1db7a2fcc"
    sha256                               arm64_sequoia: "703fb4c894e21fcca01633df86341148ba45e52f67abc98e7e437dd47e32d3d6"
    sha256                               arm64_sonoma:  "1fbb14507155032b37072c5745ce0841e8eea0f319df2696187c3f6aea730ae4"
    sha256                               arm64_ventura: "1dd1dec21adfca50b816e0c6c9e75c4a1c638d40117c8dbc17be538989e0b259"
    sha256 cellar: :any,                 sonoma:        "0641cd21135f9426bf9744dfb58d7d01ed23447e5cf62698f57d992749718ecf"
    sha256 cellar: :any,                 ventura:       "8ef5afdb60c32815e3f37d47a8436bf2efc45e62fff30696997361147ae9a2b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf1c2826845aca4d72e6711ce5d4bc6ed3189fc28be3b6c3e2416afdf6df378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67fa3f1f07fa82e992011ae264497487b2b938dfd9fc5f7cc3a22d832c94f1e1"
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
