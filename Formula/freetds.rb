class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.12.tar.bz2", using: :homebrew_curl
    sha256 "1c5a86ec40f3475a46a6ecf472aa4126f1add9f7bad1acf268820f1baec6c16b"

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
    sha256 arm64_monterey: "3a800bf77f14a48c5c61703fa69df897420ae1e457aae4c3546e88b6559fbe0b"
    sha256 arm64_big_sur:  "1dd8560b2d5c903ef1f99142a4301eed6671aeda8330410f2d9dea2808b47d8a"
    sha256 monterey:       "ca036940ca5701fb711de36eb6bf4bff18df4265e1acaede9e572896145d0be8"
    sha256 big_sur:        "7bd4e3e1a1e6bf87a8c5fbbaa4bfd883d715eabfa7df093fea5986044e7bd929"
    sha256 catalina:       "d7b10c5454404631d71638683464342fb99550bb39443945b0dc084731331b3f"
    sha256 x86_64_linux:   "57e7a7958a25c3216b28ce0fd11e1ada9cccfc9363acd8df07daf112a19006b8"
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
