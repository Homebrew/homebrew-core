class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.5.19.tar.bz2"
  sha256 "0dc2df2fea9934e3a99e00d417f3d192e9897572f6aff3905bd48f2507d16dff"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "b0eb61b463d521f6cd42af3ac201894f4fa0c74f75357cdbbbecc9640d2824e5"
    sha256 arm64_sequoia: "df9e2fd1fd5a5db20d45ac9e984faed821c5670048053bfed54fd9ed653ee2e7"
    sha256 arm64_sonoma:  "e96dfe999ccb7345619352b5c82351ce156ce4ef795ecc2165762248970533e2"
    sha256 sonoma:        "03b6477d1d6c762d741a44a9467494a6ab5397e673a84647a3b7b72b1b1901c4"
    sha256 arm64_linux:   "b61b900dbb31021d101e73005b478b2ee4eb03b84350138199710a6d09641185"
    sha256 x86_64_linux:  "98de300451af07921cbad4f678cd66a8162156681b56309247a5ec81f76f70f1"
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
      --with-unixodbc=#{formula_opt_prefix("unixodbc")}
      --with-openssl=#{formula_opt_prefix("openssl@3")}
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
