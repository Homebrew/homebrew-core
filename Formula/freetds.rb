class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.3.1.tar.gz"
  sha256 "dc8303d3b270f42309dfef04a03e17fe2ad31555df8d557c3c378bb2e9239303"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2b5b9929661cf7b448563ae715c0716ca0a5ac2755f76e4d3d6cfc4b6d8ab5ba"
    sha256 big_sur:       "7457bdc77b8ab81151549422e00dcac1fc6a4701527cc01cac4a4c6a40204810"
    sha256 catalina:      "677a2762afefb96834c262f7671507db8913f4a1b24a64b508950c02fdc28870"
    sha256 mojave:        "079d7a7c587499e764253214c405a63f8a3037fa1e34374436e2bd29f1112aa3"
    sha256 x86_64_linux:  "4f0c685a3aaf3b361fad8471c02eff079504fb19c5dfe758a2307f4a375b798d"
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
