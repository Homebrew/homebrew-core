class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.12.tar.bz2", using: :homebrew_curl
  sha256 "a2cb8993a46417e0503e7b8488463d91b8c5d9a4601d6ee2484d28f56d3a7075"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d31e8435849a2561f563e1cdd7caa662cbc578cb7f3065ca2c945bd2340ea5ff"
    sha256 arm64_ventura:  "91058a48b75e31b3e6939a3245c03eabb0f0516b6009e3d5f20e690fec0d279a"
    sha256 arm64_monterey: "3d915c16d61e9628775896f4d0a89cd0b27ad06c454e3922fdf58e38a0e5c80a"
    sha256 sonoma:         "2b835fb842393e9f5ea4f4c4cca47706b8030f47627b487e6e6f965d882cb25d"
    sha256 ventura:        "26dcf9e0686ab2b10b0a398dbc966b576fd34d1308978f94d029959f8c670102"
    sha256 monterey:       "98c882db155f157003c97e40ce3cf8a37cd29500ca130e359277f602a526fa53"
    sha256 x86_64_linux:   "bea817203d99b5870f3b181edce1fc0aa651cf21529660e292e4e158c6afa3d0"
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
