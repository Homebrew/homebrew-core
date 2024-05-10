class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.13.tar.bz2", using: :homebrew_curl
  sha256 "4530ba865cc5bcefc7b69095ad6538d7e3aaf1c7315185edd1b5b0241bf7aa0b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "17d202c4a0a7d38a59eff8a48d6e24020f3ca42b1ddc53108725bf353f707499"
    sha256 arm64_ventura:  "d188a4802d1b92e7333c34b71fde1485ae284ed133d592d0b9015f6372e7030d"
    sha256 arm64_monterey: "d6868e91704e86bb3676d3061957b22ea0c0189dd774665c85d50430f8331f12"
    sha256 sonoma:         "c76cbef436370f95988b108f5d0f244a2a8acde8bf5497b971ac1925fffb37e5"
    sha256 ventura:        "43e51ddc46dc6fa9cd67369cdef56a323343bb74bd06d890895c5ce387ce0f5c"
    sha256 monterey:       "1c76a5641946d093d54f1427e96f1b4d49d01b8fbc125a671f338177a89d2afd"
    sha256 x86_64_linux:   "91167bb81f501d95ce1ace72cdbebf85f6f2599a81b18a70545b4bd8d2effaa2"
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
