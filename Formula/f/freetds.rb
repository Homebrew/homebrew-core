class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.16.tar.bz2"
  sha256 "bc4c8264e8656180eb53e7b08ffcdfca902ceab2dfc6b5c4ef4b2394a263ec42"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "675b5947bdb729867e04d595221d4a1ea07376c254bbd863552ce6e964573a24"
    sha256 arm64_sequoia: "e13a2c3807dcdc56a0f620f3c3c372343160ff053d30bd93e749421eaa2b914c"
    sha256 arm64_sonoma:  "e42e96cb0c2be14d3c970f4e747720486410af0a3a404340876b4645d9402f8f"
    sha256 sonoma:        "9ab321a7a4ddb7bea803607de24bd88d1a1f7eb3cb2e35eb9df159b6bbcaf9b1"
    sha256 arm64_linux:   "798cb9bfa8a2967e2662f21c932bb2d3971d9fb2d277622f8ed8efe76a85f2ab"
    sha256 x86_64_linux:  "7b6c24cddd6687d6d61c239917cf36114babf17beadf1eba3b14dc32063762b7"
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
