class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.6.tar.bz2"
  sha256 "5dec033d211559338838c0c4957c73dfdc3ee86f73977d6279640c9cd08ce6a4"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "223ba6ee22f623473c1798c5ac6a8cbcfffc13747502762b00c34e530c7146d9"
    sha256 cellar: :any,                 arm64_ventura:  "eae92d181214aaa7818e24464aafaa3d1d6d29e7be86fcf39adf4496ac78b0f6"
    sha256 cellar: :any,                 arm64_monterey: "500af23b5feb6dec85eafe558b8e45de5dd1eab07ec041bebbfaf7d930eac3a7"
    sha256 cellar: :any,                 sonoma:         "4ae96473af326e90d68209abdaa223767c960897ecc31475011a2d7db25f8846"
    sha256 cellar: :any,                 ventura:        "b9a29b711f1af52d4281aab207abd97f75a5c77311340530f593b145144739b8"
    sha256 cellar: :any,                 monterey:       "7661850e603693bd72e221ce0ee95b238e8bbbccd11a02917bf4f1af16b235aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f1191ff66899afd1cff60fcceb066de15bb7c7d0ffe9b3e79303f01e35c877"
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
