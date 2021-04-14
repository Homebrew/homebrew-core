class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.2.20.tar.gz"
  sha256 "0d4808d4e1ae5ecddc89c70402e6719eb3b41121c0c5d5af456c050615e3df85"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "521ce9efc9f53e89fcdb010b217df0f0347ee87b82a37a604a53c473a154e3bf"
    sha256 big_sur:       "fdabe9c7b3941c97bbe742f9a3807b40e708b930e2433444942cccfb6599bb08"
    sha256 catalina:      "f2254a22e731bdb0cbcff133e5237a9d962c561208dd7fbe55edd02db6702486"
    sha256 mojave:        "dbc342082bd4b9cb8fcdd0a8e722c59ad08213ed75b11ad5c1c14fd30b337c8c"
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
