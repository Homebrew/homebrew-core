class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.4.tar.bz2"
  sha256 "bbb43f032b9164d86c781ffe42213a83bf4f2fee91455edfa4654521b8b03b6b"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d3d73bef8c06616d840cebb0f6f043e2390ba4ca13b8feb9f2ebc4c72241a686"
    sha256 cellar: :any,                 arm64_ventura:  "f83e2fdcb19bbb649615de9a13082c20811602a4d89f4bea8adf604ab235718e"
    sha256 cellar: :any,                 arm64_monterey: "d216e2f0a59b37e1e32d3434d277ba48416651628fd44c9c2e97ed6633e9d4ea"
    sha256 cellar: :any,                 arm64_big_sur:  "7a5e34d7d70656bc1ccd283608df4ccdb6229d68b7b67cb0f52bfeda3e962e37"
    sha256 cellar: :any,                 sonoma:         "fedcae44f9d8b7b215f5001b49e83ecf8dc15cae2f6cbeeb6a6852c06002a5f6"
    sha256 cellar: :any,                 ventura:        "dc6d96b61291f653a7639b3febeb732cd98c0ed0f7e38c24445d466be79ed451"
    sha256 cellar: :any,                 monterey:       "7d9bdc88d94a25558e7c4c577090156cc339e644ca074f587a82a89187b579a5"
    sha256 cellar: :any,                 big_sur:        "b2c80c0ee6dab8eb5562a92e10efa2b538debd5398cd473cbb3e7234b8a4ce57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74942c849eae904fee71dc704a301fd3bd9450b3222299e81c166a9aafd716f1"
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
