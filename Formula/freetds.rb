class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.15.tar.bz2", using: :homebrew_curl
    sha256 "ffb323a25450f45700f3fe9d3e3fea688678f0235bd213139519f33375dfcf24"

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
    sha256 arm64_ventura:  "3c3d7f60f4f843a434a97340b4f9ee4bdb3094b6fbb74457b516fd910bfd1e9f"
    sha256 arm64_monterey: "e253a86e690954b9f4be417ae4afc9944ee2f8110d1df2858e4d60947c1a9135"
    sha256 arm64_big_sur:  "f47e3019362df5428ced3f30d6de428baace896ea3ce0b85ec9934fe6cb01699"
    sha256 ventura:        "8289c312d5d2faf5b2838f746d67a2a80a438deaa7a7d461965fc5e6b982ba34"
    sha256 monterey:       "51bb79c2e30275ac854001b1c0f85e286bb7449ff0f0795198a073b63ae585aa"
    sha256 big_sur:        "905dbe3f3d49130c575ed7c2cedda569c34d934c7e38bd87f2736f1c55cbaab1"
    sha256 catalina:       "df88cdf73a1cb89ca8b46378c2b837729804b6b3031c0ed49cccc543edb34590"
    sha256 x86_64_linux:   "7ddcc798280d6c4cb9591705ca4a86ffaaad37eb490c5574faac07e5bf70d82c"
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
