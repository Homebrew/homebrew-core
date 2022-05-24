class ImapUw < Formula
  # imap-uw is unmaintained software; the author has passed away and there is
  # no active successor project.
  desc "University of Washington IMAP toolkit"
  homepage "https://web.archive.org/web/20191028114408/https://www.washington.edu/imap/"
  url "https://mirrorservice.org/sites/ftp.cac.washington.edu/imap/imap-2007f.tar.gz"
  mirror "https://fossies.org/linux/misc/old/imap-2007f.tar.gz"
  sha256 "53e15a2b5c1bc80161d42e9f69792a3fa18332b7b771910131004eb520004a28"
  license "Apache-2.0"
  revision 1

  livecheck do
    skip "Not maintained"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "518a6148d100fb7e9fb1307614360a7b5561b1587eb3d6aac7e643410876c117"
    sha256 cellar: :any,                 arm64_big_sur:  "c2f21ac938fd8cad640bb7c5ffc7f9fbc74d783485483914554742f0c1fe0cd8"
    sha256 cellar: :any,                 monterey:       "3f1c9829bc54fac3ee895b1e411f05add6f7f85e0482836483b1f46ef14d29bb"
    sha256 cellar: :any,                 big_sur:        "fe7f15381a9216ce51e4b2e89c9243bc15569948c896ce122e561bde9e85d327"
    sha256 cellar: :any,                 catalina:       "df3de76ba2934218f8f484f2d7e6c760956ba52eecacdb1b623d0b54d872165f"
    sha256 cellar: :any,                 mojave:         "19d971ab778840ba44c24c3eef1316d1c65e6e0b6e1540933ad051c77ee745e0"
    sha256 cellar: :any,                 sierra:         "8c1c4d2cbbd6df372f258d7cc95b040db4f3c759c8928cfbde7c54da4fa6a426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9548b94b2c2dc20aa41a9805d062d4d4598be6c927ce7a42e6aca860ff40be"
  end

  depends_on "openssl@1.1"

  uses_from_macos "krb5"

  on_linux do
    depends_on "linux-pam"
  end

  # Two patches below are from Debian, to fix OpenSSL 1.1 compatibility
  # https://salsa.debian.org/holmgren/uw-imap/tree/master/debian/patches
  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/1006_openssl1.1_autoverify.patch"
    sha256 "7c41c4aec4f25546c998593a09386bbb1d6c526ba7d6f65e3f55a17c20644d0a"
  end

  patch do
    url "https://salsa.debian.org/holmgren/uw-imap/raw/master/debian/patches/2014_openssl1.1.1_sni.patch"
    sha256 "9db45ba5462292acd04793ac9fa856e332b37506f1e0991960136dff170a2cd3"
  end

  def install
    ENV.deparallelize
    inreplace "Makefile" do |s|
      s.gsub! "SSLINCLUDE=/usr/include/openssl",
              "SSLINCLUDE=#{Formula["openssl@1.1"].opt_include}/openssl"
      s.gsub! "SSLLIB=/usr/lib",
              "SSLLIB=#{Formula["openssl@1.1"].opt_lib}"
      s.gsub! "-DMAC_OSX_KLUDGE=1", ""
    end
    inreplace "src/osdep/unix/ssl_unix.c", "#include <x509v3.h>\n#include <ssl.h>",
                                           "#include <ssl.h>\n#include <x509v3.h>"

    # Skip IPv6 warning on Linux as libc should be IPv6 safe.
    touch "ip6"

    target = if OS.mac?
      "oxp"
    else
      "ldb"
    end
    system "make", target

    # email servers:
    sbin.install "imapd/imapd", "ipopd/ipop2d", "ipopd/ipop3d"

    # mail utilities:
    bin.install "dmail/dmail", "mailutil/mailutil", "tmail/tmail"

    # c-client library:
    #   Note: Installing the headers from the root c-client directory is not
    #   possible because they are symlinks and homebrew dutifully copies them
    #   as such. Pulling from within the src dir achieves the desired result.
    doc.install Dir["docs/*"]
    lib.install "c-client/c-client.a" => "libc-client.a"
    (include + "imap").install "c-client/osdep.h", "c-client/linkage.h"
    (include + "imap").install Dir["src/c-client/*.h", "src/osdep/unix/*.h"]
  end
end
