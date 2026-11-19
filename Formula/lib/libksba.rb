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
    sha256 cellar: :any, arm64_golden_gate: "aab958865fe3fc7810bb03912472c6392b5a5a50f7482bef223711e3d323bbb1"
    sha256 cellar: :any, arm64_tahoe:       "0d843abb9cfa9de950ff2bfff1a7d3ac59a8fbde62887075dbd0399913326275"
    sha256 cellar: :any, arm64_sequoia:     "8cf9f4148f5b71450f0ccf5002e087f9a3a80b6a074d0821b6299bb6d05d2058"
    sha256 cellar: :any, arm64_linux:       "f50c8ef26457df3057ce964590bbe24d4ab911cd4e7e6a1fc2b30e7bce641e20"
    sha256 cellar: :any, x86_64_linux:      "8402c17e39064e4cb5ce27750b4d0dae1e42b979b14cc61acd97812dd0d980c8"
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
