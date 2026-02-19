class Ntbtls < Formula
  desc "Not Too Bad TLS Library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/ntbtls/ntbtls-0.3.2.tar.bz2"
  sha256 "bdfcb99024acec9c6c4b998ad63bb3921df4cfee4a772ad6c0ca324dbbf2b07c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/download/"
    regex(/href=.*?ntbtls[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "242c4613a71bbc1bae7b6ce91cd219bb73f24bb7ca50a01515854870a793b159"
    sha256 cellar: :any,                 arm64_sequoia: "5d96fef86e0e6421ac37c69453a98248c96635b2b6d8fe5b67faac129a8da5c8"
    sha256 cellar: :any,                 arm64_sonoma:  "2f3513ae1ada0a0bf25e67dd8b9d15fc4eca6a77b290ac0d5882ffae79e58098"
    sha256 cellar: :any,                 sonoma:        "cd6a5117a9c9d119a99cf6a3154b33e8f01b41228215b69d923d5165e7bbe0f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "294a59c47fbee91fcd03e080118abf40f291da8b38f1ff4e0ed30ee4bf6cc184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e34595f0b0cc8e2920c65565226c459f16c103cf1ac7e687067bce67762fba66"
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
