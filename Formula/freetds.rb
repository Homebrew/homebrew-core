class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.18.tar.gz"
  sha256 "a02c27802da15a3ade85bbaab6197713cd286f036409af9bba2ab4c63bdf57c3"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "e1915b8ec9a59b5146e50310e778c4cc247df3d12bdfbd41fd1601abc68d4a5b" => :big_sur
    sha256 "52a717a13ff3fb2541c2dd1ff55448f9201712acf875f740282b5ebf3c207128" => :arm64_big_sur
    sha256 "d50d6963a87b72230cdd9c30e17a05baf73970b26d2ef031e9496181bb41afad" => :catalina
    sha256 "fce5977a4c8d363777846b434747d5dd6207e00273769e31354d090ed35d9a00" => :mojave
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
