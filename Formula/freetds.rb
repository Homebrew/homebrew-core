class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "LGPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.8.tar.gz", using: :homebrew_curl
    sha256 "58d3a531aa9b7ea48ae1214b87c5db1ed109458905f5baa9f6c1797ce9a7eeaf"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "00fc9202b0f05a0799e1552a07b5aaf3dc646b8663ee0acbf4acf0cad56615fd"
    sha256 arm64_big_sur:  "dfd7b48b9f9dae1b2738539c4d9243b775d89360faa4d3ae498991ef995e7716"
    sha256 monterey:       "13aa339e1efa4d6718ddf4d8db862f044869af65ac796b4436e4837cac3d7029"
    sha256 big_sur:        "8d5a3022198800395d6cb8735f264c14bb367190e41cc1ee1fdd8d5704ed1a27"
    sha256 catalina:       "328c91d6ded280e017288f277d8e5c9592a93f6d799a600c03f00117dc1e4cac"
    sha256 x86_64_linux:   "b29593efb4e5428c02634fb157dd7bfc97129dfcf97b9e638179771e03e0ba88"
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
