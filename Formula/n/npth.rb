class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.8.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.8.tar.bz2"
  sha256 "8bd24b4f23a3065d6e5b26e98aba9ce783ea4fd781069c1b35d149694e90ca3e"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/npth/"
    regex(/href=.*?npth[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7dc8a83801469950381677b61404e103e5fd8fb22bc6b4e0f68db292d5801e3a"
    sha256 cellar: :any,                 arm64_sequoia: "7836af0109be87ab2b8155b533cd33508eb3b738190031c8ca2e2b94df6f5c2b"
    sha256 cellar: :any,                 arm64_sonoma:  "fe1fe3f063148f11e6ef6182846b1a23177faca872902248665bd23b1c6d6a11"
    sha256 cellar: :any,                 arm64_ventura: "7178f348dbdf184206e70c7aa62711c53c900f888bdffd1391ad709497ec456d"
    sha256 cellar: :any,                 sonoma:        "6532f31787befd9082aa4902e75bf6a0ba26b4423029b7b9c1f1117ff0d0df7d"
    sha256 cellar: :any,                 ventura:       "669a65d8a32cfd4d30a79d606702c982b474586ad23283d7ad3e1f6e40712076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae6de43d79405ea955e4f8ea018bd0660da87bb0a40c39a1f9b7759915316006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe2b3f4f5fb1b8e05b3ddbc5dddbf44d3b03b95ca9712ff4fc33cbd045368b4"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <npth.h>

      void* thread_function(void *arg) {
          printf("Hello from nPth thread!\\n");
          return NULL;
      }

      int main() {
          npth_t thread_id;
          int status;

          status = npth_init();
          if (status != 0) {
              fprintf(stderr, "Failed to initialize nPth.\\n");
              return 1;
          }

          status = npth_create(&thread_id, NULL, thread_function, NULL);
          npth_join(thread_id, NULL);
          return 0;
      }

    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnpth", "-o", "test"
    assert_match "Hello from nPth thread!", shell_output("./test")
  end
end
