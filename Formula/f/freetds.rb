class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.21.tar.bz2"
  sha256 "76e042f3c42579846a70ae19694bb8fb0bc8f6d76ac01572cfef51a37619bb3c"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "0e0c6ea54ceea8192e34ecdef5abf9b29c78a078079c0fec63108b5cfba3d58f"
    sha256 arm64_tahoe:       "3b8d6614cb468258f662d7bcc2a53fb819365745e4dd8c07e7a7db7f167e83cb"
    sha256 arm64_sequoia:     "5d3164b003333871e04f8312068fc6f6f335e4ce7013cb9e0442b4055dc0ad39"
    sha256 arm64_linux:       "ea0552d2a40087c760165287762876e35a99850e3bb094d4e338c0a239d4c220"
    sha256 x86_64_linux:      "f65ed11d5d91cf605454339db7307f613c321518468fc670f5903044d54910c6"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"
  depends_on "unixodbc"

  uses_from_macos "krb5"

  on_linux do
    depends_on "readline"
  end

  deny_network_access!

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{formula_opt_prefix("unixodbc")}
      --with-openssl=#{formula_opt_prefix("openssl@4")}
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
