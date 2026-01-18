class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.10.tar.bz2"
  sha256 "b5aa4377a669b266ff26f2d11893e65430bef377eefd92934832310774dc6942"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6332e13106d040f06a9b2354466d22e2d64452fe9fe65147b513b10df9abca8e"
    sha256 arm64_sequoia: "0b060b09ff8fc404845af0760c95510c5a3b63b23cf8585cf99ef2187b1e1f87"
    sha256 arm64_sonoma:  "c63b5d48f1f468c44c226c75af2eb63e568eefc5db760d2230e49b238ec343e2"
    sha256 sonoma:        "08e8352758acf0e75a4aee5f16b3a14a3adc62342e1bcbd5f5afeb94904918e1"
    sha256 arm64_linux:   "ef0325f1935363b9c8e5156ba62b0bd5b53d53123cc23f929c062a56166fc593"
    sha256 x86_64_linux:  "66f72ba1cae122e1f09a258aab22dd19313b2d886596c839ea3b638f125da99b"
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
