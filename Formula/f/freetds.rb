class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.26.tar.bz2"
  sha256 "74641a66cc2bfae302c2a64a4b268a3db8fb0cc7364dc7975c44c57d65cd8d1c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a85a8647355317866438fad77b812ecbec0d378bc6b7a07f10f0a43fc2f04611"
    sha256 arm64_sonoma:  "1556b1886e260863ebd34fc175ce90fcab9b2f6c45a5e38178720bd90be36c8d"
    sha256 arm64_ventura: "32976083451f3f999a77e2742f05e3c138ac74c5589a14040e96f4302ceff55b"
    sha256 sonoma:        "59d5b369e62435f4c9d9df0de26fd67af5cd85996b6e98bc183eb9e1e3a36526"
    sha256 ventura:       "f4254b67ed5d693440c0875290183e42dca46e2ea512aaa8bc695e97ed29eaf8"
    sha256 arm64_linux:   "500d5e13fb9ced5c5149fdd9a13d6fa345e304652ea73d149628274853ec2ce7"
    sha256 x86_64_linux:  "a263c006e43ab07d412f9f775b01d0c61e11789cc45883183e307e2843844861"
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
