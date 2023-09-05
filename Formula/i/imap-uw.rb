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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "853cb9eabed350f511e68b7198005a276b86efecf79846ed68858d226df546de"
    sha256 cellar: :any,                 arm64_monterey: "52ef7c6c326e06a85524eab3a22f29ff095877b1a640979958b72cede3dc8758"
    sha256 cellar: :any,                 arm64_big_sur:  "3598566905f97346d6691c708ae0c6673d28924265f5e10d33bdb2f8d40aa90b"
    sha256 cellar: :any,                 ventura:        "3752df02ec24ffaed9fb630721492c24647a5426a0b53678fb4d574b1c99babb"
    sha256 cellar: :any,                 monterey:       "b103e67bafbc727288fe497dc634d65489b9c9272ed23971a35348988e0fd21d"
    sha256 cellar: :any,                 big_sur:        "03c5fc6a4e888a756809749d359b45141b95fbb8b3cfa662ebd9687e55ba958a"
    sha256 cellar: :any,                 catalina:       "f98ac44c956015b954474247210e3b19dbcf629280b69ab2c33386ad6f298c31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b87416d2dcf7b2384df72ef50f309556b3e4e267eedf11f05ae54b53f67c8a1"
  end

  depends_on "openssl@3"

  uses_from_macos "krb5"

  on_linux do
    depends_on "linux-pam"
  end

  # Two patches below are from Debian, to fix OpenSSL 3 compatibility
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
              "SSLINCLUDE=#{Formula["openssl@3"].opt_include}/openssl"
      s.gsub! "SSLLIB=/usr/lib",
              "SSLLIB=#{Formula["openssl@3"].opt_lib}"
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

  test do
    system bin/"mailutil", "create", "MAILBOX"
    assert_match "No new messages, 0 total in MAILBOX", shell_output("#{bin}/mailutil check MAILBOX")
  end
end
