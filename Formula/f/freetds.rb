class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.10.tar.bz2", using: :homebrew_curl
  sha256 "c7eaf226bdcb1cdc1b221696532ccd25f4e4e7754265a29777a3400084bde698"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "315e12474cf2c66f4ef2e5aa2bee074a7519cf684b8a620aa727574bdb535ae4"
    sha256 arm64_ventura:  "356939e0d9ebaf186aadd07e3415cd169bf792d42a5266876a2c1f476f1173a1"
    sha256 arm64_monterey: "cbc68148468adaeed5729454c328610e3938306d12cfd0bc735e388851e651ba"
    sha256 sonoma:         "eb057539545529411ec00449559360e570c009398aa22574f9f98aae6ce9c19b"
    sha256 ventura:        "79f9bbeb9ecbaa828722baef4a2613b94ae7059f04f031f971a5c71723b591c6"
    sha256 monterey:       "25d5b36975a97e4689b963a026ed1420f816b461d502c8a74030f167986e1988"
    sha256 x86_64_linux:   "ddd888f2fdacd03be1195029e9a9ede1593dceef4b81677f86718e9f199312f6"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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
