class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://www.freetds.org/files/stable/freetds-1.3.17.tar.bz2", using: :homebrew_curl
    sha256 "f80cc01a0ef5bbe33e7cbb3702ed924aab5e25ac6eccd93c949e87dfef7c5984"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "2cf1f35b95f63c8a04b2a3dbb409c8cd937d5eec106ac618b8cf72c5e5e9b3e2"
    sha256 arm64_monterey: "0a3739275e2832e9e8c52440d5f60532d2caa6b0e81c7cd8278799654f9105ff"
    sha256 arm64_big_sur:  "5eb75dbd48dc5c998c754e13df5c5e518f5a00882d17a3f6fff28adfbc5b0f8f"
    sha256 ventura:        "dd5a84af9b40c74a186b5db8e50a851e6f9769b394c1aa1514d41e98d0a1ccf4"
    sha256 monterey:       "d0f06bda633e1889c4bf41b89685d2396dbd87899a2a4faa23b5b50c82a28fed"
    sha256 big_sur:        "8fbd7b1169650cd75b68b2057741520ebe87610cd2ab54c3bc51bf5225ad4e26"
    sha256 x86_64_linux:   "30fca553d0810e54d0b6e6e8fd12e11ccbb94ebe80d1045ce7859d06e017ae45"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
    system "#{bin}/tsql", "-C"
  end
end
