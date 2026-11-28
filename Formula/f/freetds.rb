class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.22.tar.bz2"
  sha256 "b31cbc50f9e2ad4adf8dd3958807e4e7b8f4e588b080f8dbddbe465ceefb9231"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "7febc3db20e7c841f7635eaaeb15523fad0ad2a2ecd4d5c114be1a1d4ae50494"
    sha256 arm64_golden_gate: "938bb72503154d9282a030b9fdabb3897e9608a4d0c5520eab47fa59d638e262"
    sha256 arm64_tahoe:       "324e24580da6db09ed3c22f8ea20224aee7165e3cbdd0ebe10b97d0377941e32"
    sha256 arm64_sequoia:     "5ea438e7b8c0a51165e5bd16f32213af09af2dab5ae8a1f3050a3a990dfae05a"
    sha256 arm64_linux:       "7efcf957eca446a840aa95ce53b800442c0132c7b0cabc6118a349c162af71cd"
    sha256 x86_64_linux:      "e7cdc7534b43fd1729adedeec40e5950695fc4371d0b24c78b2dbac4e633477a"
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
    openssl_prefix = dep("openssl").opt_prefix
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.3
      --mandir=#{man}
      --sysconfdir=#{etc}
      --with-unixodbc=#{formula_opt_prefix("unixodbc")}
      --with-openssl=#{openssl_prefix}
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
