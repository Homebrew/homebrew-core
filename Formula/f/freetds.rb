class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.2.tar.bz2"
  sha256 "7100a723bef1c0866f0a12c7081b410447959c8b9cc7500196c5c5d64042c056"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "34b68f15856b88130e78e4a2fb9fc5bd488c5376287fffb77191a29012bc8b31"
    sha256 arm64_sonoma:  "8e4599c06d73ce7ea11774f1e0dc52cb47c46b6124a81225809caa155132a7f4"
    sha256 arm64_ventura: "fba040b11c7e380402d4257fae64bd1a6d551147155f544701792745dc010eac"
    sha256 sonoma:        "9a1a9b40cc221055d2ed01e2a94477970fc7d156fd15303a831becbed38c50df"
    sha256 ventura:       "63b30da37a69f7035ade295ed1c9c1ea9e8d57565c3db858bb2eb8e444d49ebd"
    sha256 arm64_linux:   "a4f93c5ffdd1ae2cfd43ef1032a24efa4a6cb650fe89d703714a546f8791ca82"
    sha256 x86_64_linux:  "96cba8506e16e5fb8af543b51f728f522846cb9c8832d7788e891c9dd72fcb5f"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "unixodbc"

  uses_from_macos "krb5"

  on_linux do
    depends_on "readline"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system bin/"tsql", "-C"
  end
end
