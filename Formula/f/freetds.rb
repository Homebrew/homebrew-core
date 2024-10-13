class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.23.tar.bz2", using: :homebrew_curl
  sha256 "93a3f186b82c6042a66a1970bd478d7914edb1c5669b642d80b4eaacf2a2d17e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "038c79a890f8bfa86b4ad80b023a5d2d159e5560ee9fff8cb4843b744c35017a"
    sha256 arm64_sonoma:  "567e374c5d48379edfcd1a337b8c2276369beee0a2c1feedf0286f4085919888"
    sha256 arm64_ventura: "59d2dd5e0115c72865f8a2be26c6fd592f3c0b42029749e1d2f3c5ca206a21c6"
    sha256 sonoma:        "47ec787d486077556a1da8a31107f49177c7db669d90ec3136f8ca2f7c5386ca"
    sha256 ventura:       "a5844d1abc79fb45eadd6c8bff150e899b8afed949c82bb161ffe232bd99c461"
    sha256 x86_64_linux:  "23ed83a76e8d45128b5ca26d4b1ed3b44c5738b1aa23149cc8045e6ecf08b057"
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
