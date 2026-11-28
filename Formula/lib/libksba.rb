class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.9.1.tar.bz2"
  sha256 "9afdd398b4a076735e1e7fd29c7f6e7670b6c382aee2d3a55aa937b283f43e5b"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "31b5adbdf677b2a99247e1e699f85586f80c60bd41961d0a8906a1902e3e2359"
    sha256 cellar: :any, arm64_golden_gate: "4cb6869cd67ee2115f8b85193b6fb56a867b932153dbd85b206114c90ea42555"
    sha256 cellar: :any, arm64_tahoe:       "79f0d77f0480999dd683fd0cabbee577edde5a517398c87ead5be8470bf8a0c1"
    sha256 cellar: :any, arm64_sequoia:     "2cdf1a06c2cb405d24f467ad27260578961d12adf635bdb8b84e9e4e7d50606d"
    sha256 cellar: :any, arm64_linux:       "01925d0ed41e88c0ef2bb764bbd8a9c12134aa1885a51d1156142189acd3a5c1"
    sha256 cellar: :any, x86_64_linux:      "9c15459ad420b1a617da08a92967f889a1fdb20358de1130fc777fef5aaed4dd"
  end

  depends_on "libgpg-error"

  deny_network_access!

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
