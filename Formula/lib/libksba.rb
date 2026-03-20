class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.8.tar.bz2"
  sha256 "0f4510f1c7a679c3545990a31479f391ad45d84e039176309d42f80cf41743f5"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e215941d6b5de0e4f42f1befd1dca741d8892c2d4bbf0b111279d4c407867cc9"
    sha256 cellar: :any,                 arm64_sequoia: "2b47d6ac53379c370b6d9a03cafea11eb1e95e8bf9dcf11769f8c3c20e046a4b"
    sha256 cellar: :any,                 arm64_sonoma:  "3d6a334dba80647d80cb84875d2e78ca20170bcb7da7b03ea4ebdeb435d18029"
    sha256 cellar: :any,                 sonoma:        "82ecf77c9ae90005a5ac695f034b352dcdb75ec0b846dafb17c4746c81ae8d5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "470de20803e3d667949abd7e9f6d80057cb3859d88faf040c7009b2e0c416941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31eb43893e7dff26f077fc9670f8b6180af7d84aefaf1e1d6883c238eb5e91e0"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace [bin/"ksba-config", lib/"pkgconfig/ksba.pc"], prefix, opt_prefix
  end

  test do
    (testpath/"ksba-test.c").write <<~C
      #include "ksba.h"
      #include <stdio.h>
      int main() {
        printf("%s", ksba_check_version(NULL));
        return 0;
      }
    C

    ENV.append_to_cflags shell_output("#{bin}/ksba-config --cflags").strip
    ENV.append "LDLIBS", shell_output("#{bin}/ksba-config --libs").strip

    system "make", "ksba-test"
    assert_equal version.to_s, shell_output("./ksba-test")
  end
end
