class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.6.7.tar.bz2"
  sha256 "cf72510b8ebb4eb6693eef765749d83677a03c79291a311040a5bfd79baab763"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c0837ea16c7dec40970bec524c94f5534f0f0a138a81b231006185bf0be7aaa1"
    sha256 cellar: :any,                 arm64_sequoia:  "4446cbe4b0a27393b01c2627edfad9cfebb8a55fae70750977ec786d4598e64a"
    sha256 cellar: :any,                 arm64_sonoma:   "0988bac20ad406ec6d0c8ba7f141b320d3752a8c73e20596b0a9dd004769b832"
    sha256 cellar: :any,                 arm64_ventura:  "5ec4bdc07e17b7a9a853035d6cce36d5f06a02d023b16c42da83eb7d81faeeb4"
    sha256 cellar: :any,                 arm64_monterey: "7e610a6f976663698f835eedfe4327f92258a0a5faf9ef812b1318aa659e41d0"
    sha256 cellar: :any,                 sonoma:         "7fb376fb9a021c347e3ffa9a2b91abf42763bcac15457238b0dfb2dfbf6b309b"
    sha256 cellar: :any,                 ventura:        "c296bd13b1b83cba89ab5cf481de5d8b00f1396008daf98cb5724924b19627e9"
    sha256 cellar: :any,                 monterey:       "926a6f72ba9c7ba6701e93ecc4849f13661e558f82b95f5c86b2786f3b46c4f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3930363cc2716c7c0d487b518cfdd2955e72671af0ad494d40f7075ca32303d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2110f07bc9d32f299877e050db0b52a138b8c28f8fac2502585dfa5698e783dc"
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
