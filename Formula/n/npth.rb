class Npth < Formula
  desc "New GNU portable threads library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/npth/npth-1.7.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/npth/npth-1.7.tar.bz2"
  sha256 "8589f56937b75ce33b28d312fccbf302b3b71ec3f3945fde6aaa74027914ad05"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/npth/"
    regex(/href=.*?npth[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "43b266d6b31d03496cb2635869fa4e650b359ed52471531d846a38436ba0b4cf"
    sha256 cellar: :any,                 arm64_sonoma:   "7a27b607cf154ad94b9d28f46f82d80077f93c04a6ac99a9318e94fa2323056e"
    sha256 cellar: :any,                 arm64_ventura:  "db0711bb0c5d9a5ae7d2cac37c726c7663c54519dc8fe9f1f8a234efe3e519e9"
    sha256 cellar: :any,                 arm64_monterey: "a88c8c762a7517924f816f92ea4ae300a411e35664585dcc0c5ed9b176c54a08"
    sha256 cellar: :any,                 sonoma:         "5ed3c6ccfb00a439f809c7dc6b3087b7821e9dc8ecc15faef4de5b6bcf2182ae"
    sha256 cellar: :any,                 ventura:        "1c2767f23e99b04caef86211248f1eae7c247e080c4e41e36d019e90c30680e6"
    sha256 cellar: :any,                 monterey:       "51ea186258914749ae2fe51f5bae3ef9bf114a693e58180b5744702f22aa8b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68467d74c01067d5b8d137e395bd793ec97cd94788856ec5f84f98eeb8d93d65"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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

    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnpth", "-o", "test"
    assert_match "Hello from nPth thread!", shell_output("./test")
  end
end
