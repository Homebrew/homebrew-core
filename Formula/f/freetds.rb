class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.12.tar.bz2"
  sha256 "f507fc9ce7bd7c0aacbd2f19d83ea5a0ae5856455cb4a92a762b03612b314df9"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "624932a3c8d67ee2febdea49e7910e36684cb3cda1ba314bdca5381a190f3638"
    sha256 arm64_sequoia: "2e7d1be97352ae051c975153e4cbbaa387fc9fb6942b4aa5d8dc078fcc68c3b0"
    sha256 arm64_sonoma:  "d4a690bfed0930b9e4b21a5a25860dd282f39ee88c267bda2d5f6de765c1e48e"
    sha256 sonoma:        "08ba73b4238768e3cf6fc74c10b05197a761d803c271ce282a9d258af4a25320"
    sha256 arm64_linux:   "588dbc099f27f115d52a8c9105ffb1d46224b3c248775d8d0417c7d6aeee2051"
    sha256 x86_64_linux:  "ac9a04def4f46a711cddb4ca492ac3416c6806d7dd9b17b37eae64dc46f112a0"
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
