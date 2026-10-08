class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.19.tar.bz2"
  sha256 "0dc2df2fea9934e3a99e00d417f3d192e9897572f6aff3905bd48f2507d16dff"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "cab9c7bb5b3612f23e92022fd4669c34848e4d2fe85b1e8fba38c777e3462eab"
    sha256 arm64_tahoe:       "dcb36b94451805b1fb5f114766ae22ad7088748d42510df31688becbe5378214"
    sha256 arm64_sequoia:     "a2f7136be85c9197685c90cc8f65a537a093613aaef4ae87e33707d3f0cc7c32"
    sha256 arm64_linux:       "318f9e88bc4bcfc00c9985ace0976ff7305511c8d79ce1d339a27626c65e539f"
    sha256 x86_64_linux:      "d350e66fad5101a51f27ac20e5c216b9a9714740070c1dd41d141fa58d3493b2"
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
