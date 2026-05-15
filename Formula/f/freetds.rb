class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.17.tar.bz2"
  sha256 "6dee48026b7e3e2393d3ea3ce18f8f81a74d6a0f300e9951981ed7bf4de6bbc3"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "616b5b50579b17a3133aada2d324f3236bc17fefd205fed18165943a754f1a7b"
    sha256 arm64_sequoia: "5c2c902ad30b4f1b268de8f572672d732e203d0be5bde83e5be5c53cdc55869d"
    sha256 arm64_sonoma:  "4b7bf09b1f58e591b88fa390d09e54d3e3d55e9a71b2b3cef2ede1892d123d38"
    sha256 sonoma:        "ad09bf1c73d5d3aca6025db5130ee68493f93b47d017c89d5989c36bef6bcbc8"
    sha256 arm64_linux:   "578276263562297c6ff59ded41056105a60e3b7b12355adc883826a4f51d364d"
    sha256 x86_64_linux:  "31e0f2d9271ba916ed002b1e2a8ba47c5954d8ae791e12681eb9a7a803321875"
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
