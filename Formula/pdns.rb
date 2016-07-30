class Pdns < Formula
  desc "Authoritative nameserver"
  homepage "https://www.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-4.0.1.tar.bz2"
  sha256 "d191eed4a6664430e85969f49835c59e810ecbb7b3eb506e64c6b2734091edd7"

  bottle do
    sha256 "a4c88ba530128cff489e1267e6970c89ec1019248d33cc033e1a2672f7b9e7ec" => :el_capitan
    sha256 "45dd89931b7b94e779ccdec204dac373fa9a3b5869944cfbf01b3a150c59f730" => :yosemite
    sha256 "69ed11aa0eb0e223e498f8a2181322a706349ecd95d3a6a02cd670c6d2dbbe1b" => :mavericks
  end

  head do
    url "https://github.com/powerdns/pdns.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool"  => :build
    depends_on "ragel"
  end

  option "with-pgsql", "Enable the PostgreSQL backend"

  deprecated_option "pgsql" => "with-pgsql"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl"
  depends_on "sqlite"
  depends_on :postgresql if build.with? "pgsql"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-lua
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-sqlite3
    ]

    # Include the PostgreSQL backend if requested
    if build.with? "pgsql"
      args << "--with-modules=gsqlite3 gpgsql"
    else
      # SQLite3 backend only is the default
      args << "--with-modules=gsqlite3"
    end

    system "./bootstrap" if build.head?
    system "./configure", *args

    # Compilation fails at polarssl if we skip straight to make install
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_server --version 2>&1", 99)
    assert_match "PowerDNS Authoritative Server #{version}", output
  end
end
