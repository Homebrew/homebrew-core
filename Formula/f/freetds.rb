class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.9.tar.bz2"
  sha256 "a58fac1ba9ad21ae1d09fdb499be9910c566b90863113ab58ef617ba9663601a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ce447de094473f64e0696e019f416d5a72bb60b0c8c15ec564bd7a60719c3a56"
    sha256 arm64_sequoia: "91a2cfb0f6f69678b730b8d2423610a5455ceb31893b45d94cca84b11cb56f9a"
    sha256 arm64_sonoma:  "28b90de9155e3476c025f86e3a906aa406174435273c64ae9c660a252b2b6de5"
    sha256 sonoma:        "411a45f3c3e9b3b1d4a805dbc74b616356c1390af752cd465fa38c31a95aa3e7"
    sha256 arm64_linux:   "6d1ac30b3412b6bf85e6328edf898f4e9243faee76ced0327fcb967574ab4d9d"
    sha256 x86_64_linux:  "80b4eeb4143ce4f1e8d6a6763f2ec3c0c1a57363222ae6341e956f6ed567c5a0"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system bin/"tsql", "-C"
  end
end
