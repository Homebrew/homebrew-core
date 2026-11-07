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
    sha256 arm64_golden_gate: "407f4a714be45488ef941f825382025210f06e3fbf73442ef03e04d7a42570c5"
    sha256 arm64_tahoe:       "d212e314a1da76c108fdb9c48044c14c3a8e8dba135c87acf7ae41377326edc4"
    sha256 arm64_sequoia:     "70a7207d61cc46931c386133d880220e015d4e712ddc8014168fe5d9755c543f"
    sha256 arm64_linux:       "81b9bf9629339d44f2721d4d5d540a453cf3dc1215f4d4a846373991ded08e8c"
    sha256 x86_64_linux:      "7e8f529c06710260c2c2d6395deaeb3de34845258ff6f6321e5fdd297d584ee7"
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
