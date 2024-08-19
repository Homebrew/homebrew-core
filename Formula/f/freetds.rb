class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.22.tar.bz2", using: :homebrew_curl
  sha256 "a9a7f24f0a7a871617e76e8cc6e6556ae788042f1c006195665505499b2334b1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6b0ba395d6481eaee3b7d22c9ba75a8acfad011574d38fb3cc7114c7703a0a31"
    sha256 arm64_ventura:  "6a3f546650f661ee8a9fbf795059331b520d79ca9b71501d40976eac02018484"
    sha256 arm64_monterey: "71626b498421c3a2fff405fabcf719cc281ee741e04015859a10d8d9b4e27903"
    sha256 sonoma:         "fec7dbfceeac7e55026304016043527306e60c3aa436568e847578bc5e58ec5b"
    sha256 ventura:        "9ee8c1be602a1a03e6bb2c9ca73301d6caf7b143cbed5a781ddce959085c6afb"
    sha256 monterey:       "8d6b2f8553ee5946b9d14a0ff3218789498233d28cc44982ef8981c3b708866c"
    sha256 x86_64_linux:   "95016e2d906b036cabeae6b4d56cd048cc02c39645d0029bec74ef0afcc55e0a"
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
    system bin/"tsql", "-C"
  end
end
