class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.14.tar.bz2"
  sha256 "2422a04d6fb546f168e69dd4a8289d13ac9f53ef86fc852ab11f5e0de249207f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a3b41eb2fe8bbba550c09eff5ad4fb7e8c4c81d802a27f8856a1e21c3ffb3b3c"
    sha256 arm64_sequoia: "8ac2faf9fc4d7e85ecdd0afc3488940c767c8bffdf7433c1106f302199339880"
    sha256 arm64_sonoma:  "296aa0d131ab75e89746ec8f86ef29739058f09c0ed6b0c550d5298cc117ccba"
    sha256 sonoma:        "54c8bb9dfad33c58a5096952b1fa3cb917e1a35bd2c7254bab682c580f90043a"
    sha256 arm64_linux:   "23aa57c375f7c741be43085311618ff8cfc30d9fc65a2c3fef314e45c5a504ca"
    sha256 x86_64_linux:  "421daec42c1c2bd5c90b84c24cce77e843c364514673515e3a059a825aff803b"
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
