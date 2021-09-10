class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.3.3.tar.gz"
  sha256 "a21a0aa351185049e11e237a795a61e3ca68d2e798259b3b5ea4a9797d5a5535"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "95f5ec9318ef76fc7fd19e1e4bfbb651ce0f70c0a445734ea2eb52c9431b5300"
    sha256 big_sur:       "5efb35a0a91a02ea73b82fd739f97f1db31174568e43e7021bca6a0326395dce"
    sha256 catalina:      "24d00d8abb0e2022255cc8c57157bd348b456a2b23aa6e23698cda2707499248"
    sha256 mojave:        "c3a7e0cb9eb4e18b6ab2fdc9b96ecbf79200897d30766c47e74bf3e676aea8e0"
    sha256 x86_64_linux:  "ffb46b5fb70a425148a6747e284d9927f5a4e966d30fca5b4bd9dbcf0b71929e"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "unixodbc"

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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      --enable-sybase-compat
      --enable-krb5
      --enable-odbc-wide
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
