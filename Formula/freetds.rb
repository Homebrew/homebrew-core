class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.1.6.tar.gz"
  sha256 "f3ce8e48bc8fd08777a35c7fc0a26b6c8e7e53748c8c0afec49231df93afcdee"

  bottle do
    sha256 "501fc03b7af71fdc7dba603c95d7db725c55c09e384947b16c2ed466532055e2" => :mojave
    sha256 "05c552a1a5d92283d58ac1c40517b6cfcecb288aff000d942e15dcdc623dc40b" => :high_sierra
    sha256 "4be0a1fc8308d2c8f2f5dbb282ed98ccecd55c17413fa7d1772024068f3e6557" => :sierra
  end

  head do
    url "https://github.com/FreeTDS/freetds.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "unixodbc"
  uses_from_macos "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{Formula["unixodbc"].opt_prefix}
      --with-openssl=#{Formula["openssl"].opt_prefix}
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
