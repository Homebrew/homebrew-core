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
    sha256 arm64_ventura:  "b70825cae08b0c0fc277cf702b3d18604b76c270bd884d1716cb8e4b49cd99df"
    sha256 arm64_monterey: "2d6da1c5b01f55b2ffd4a84a2dd470efff5ea75ed7523e27d818151f317c32a2"
    sha256 arm64_big_sur:  "037ec5bf39d357ede67f761abb22015028525dbea3bb5578572b73cf5bd26b45"
    sha256 ventura:        "15efddb4828362ffefbbe9908d9d6bb526e9188adf251d797eb6dbb139df98a4"
    sha256 monterey:       "e33a34e88beef1d32e1eb00f31426f5c3d815c1b125f1337961c6574c97d67de"
    sha256 big_sur:        "60bc115fbd22d078bda57a4c2002e0b5fced90f32530dd5451228ed11d86712a"
    sha256 catalina:       "2478fa4ac10efbe4fdd6e88b2757fbcc4e20fbfc7996476d2fa0267906211238"
    sha256 x86_64_linux:   "575435e59e498629f374f91a7b53e3d99920ec674f625092e439acda76b6805c"
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
