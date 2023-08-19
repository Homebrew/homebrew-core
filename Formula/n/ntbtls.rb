class Ntbtls < Formula
  desc "Not Too Bad TLS Library"
  homepage "https://gnupg.org/index.html"
  url "https://gnupg.org/ftp/gcrypt/ntbtls/ntbtls-0.3.1.tar.bz2"
  sha256 "8922181fef523b77b71625e562e4d69532278eabbd18bc74579dbe14135729ba"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c361757ae25b2090cf20c61a99c63b378870a18004cbf28211d394cab769120f"
    sha256 cellar: :any,                 arm64_monterey: "533b91778c5105e65f9f31a698f284da5e853d21474f29c966946820dda4af95"
    sha256 cellar: :any,                 arm64_big_sur:  "9963405e4fd797d2e79fcc738a33573790f1db54ea2c8ce3b4dd59d42899a1df"
    sha256 cellar: :any,                 ventura:        "9cac627498dff2c256bb9e70a7a61da8b6ae8cafd13422e0874d6150b25c7411"
    sha256 cellar: :any,                 monterey:       "91cce326c5f72642930b47410266423fe57ddb13bda3a0e0e87b4dfa5f4fc728"
    sha256 cellar: :any,                 big_sur:        "de89772e4a075616997d20c7506c2f1a1136da23729e36c12c1efdc1535fea87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cca68bdb513aa6b35b0169e7129fb1b81a05ebb01dd9b57adb6f1758d9070690"
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--with-libksba-prefix=#{Formula["libksba"].opt_prefix}"
    system "make", "check" # This is a TLS library, so let's run `make check`.
    system "make", "install"
    inreplace bin/"ntbtls-config", prefix, opt_prefix
  end

  test do
    (testpath/"ntbtls_test.c").write <<~C
      #include "ntbtls.h"
      #include <stdio.h>
      int main() {
        printf("%s", ntbtls_check_version(NULL));
        return 0;
      }
    C

    ENV.append_to_cflags shell_output("#{bin}/ntbtls-config --cflags").strip
    ENV.append "LDLIBS", shell_output("#{bin}/ntbtls-config --libs").strip

    system "make", "ntbtls_test"
    assert_equal version.to_s, shell_output("./ntbtls_test")
  end
end
