class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "LGPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.7.tar.gz", using: :homebrew_curl
    sha256 "bf4cb1aecb0d1cd1cb41b69275df96b56132b9ceb7592c208fba208fe7244e14"

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
    sha256 arm64_monterey: "d203009c2ff863167f80411a02326956ee387cc0f0abf3e930174d9417f415bc"
    sha256 arm64_big_sur:  "38f5e44c76416ca953a012bdb857fffe7e3b83339910e3bb160ef98c94ac4ae3"
    sha256 monterey:       "3cb6c6076000df7d31cb2d22f8478b920f68ce588078084a70653f2dea44a3ae"
    sha256 big_sur:        "7bc90d9628882dc4144a5c10d2fa5919c30b9ac35e44cc1e1c8b36468f641a1f"
    sha256 catalina:       "44cc5808fdfa2407beca1d96d37ea625e9e5ae3e0fb844b85371102200f0a84c"
    sha256 x86_64_linux:   "cb8377ac326adef3086c73180905a36b1bad117d025ef58f2cd63763b93a764d"
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
