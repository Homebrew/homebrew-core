class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.8.1.tar.bz2"
  sha256 "c2f84393011827219ae117131dba8e7684c2bed0961eed11b0642c2acba440b5"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3525fe3de3234476c4d8e07607ce8481941c5e866d89c82c4f2d11d40a08f52f"
    sha256 cellar: :any, arm64_sequoia: "cc1bfa116e5e7550d0caeee4aba27203aa15ceb485083f5a6e91e6ab9c7011dd"
    sha256 cellar: :any, arm64_sonoma:  "dec0bab0bcff0c515c9b10cbe85f5f2b802489bdd19f421ce6cc13db929b5bca"
    sha256 cellar: :any, sonoma:        "e5036f50c0f5f015ac66a7d3426cc40d61c830cc52386408b410f3bcc8a7d45f"
    sha256 cellar: :any, arm64_linux:   "8d33f9a176df2946deab95be35fcbb6d2775a79fbef41a55eaf259a2d1329e6f"
    sha256 cellar: :any, x86_64_linux:  "74e720998979bbca5597eca92df39202c44229c674cc9368d578e6fbc08109ee"
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
