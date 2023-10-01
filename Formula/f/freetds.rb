class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.4.tar.bz2", using: :homebrew_curl
    sha256 "1dd62979822d46ca67635bf7114f84255016b49bd9e262f254067455238dbb70"

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
    sha256 arm64_ventura:  "c105510de006140baa9d8d93a82ef0c912606593d233c7c19d8d40d57b9a2b07"
    sha256 arm64_monterey: "fed0a6634348e3b524ed890f7acc62d3344d15380e7d37ce6ef8becc9f8cc2fa"
    sha256 arm64_big_sur:  "673225850da65966c97e49ed1c2f989c230009de31b75011203fa0594eebcdf4"
    sha256 ventura:        "5a1434ca4ae5317bcfbdff6d81293fcc388357a0008b686ea0aa705187290130"
    sha256 monterey:       "e3abd13b0815f94139d6bd6c4311ffdc7a15c312ffda6c98c61dce37d4fefbe7"
    sha256 big_sur:        "4046a8377984cbcaf73bafaeba1b99e9b04fb0e883817fcdb9374f634b2593d5"
    sha256 x86_64_linux:   "7ce29c59f8a798f8854fe072c815c096247a3064f0236643ec243e97945f24e9"
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
