class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.3.tar.bz2", using: :homebrew_curl
  sha256 "12f8b55b1e1816aec60e0d067de939c09e3477363250be95755b9b36e1c3c5d3"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "569227423a93ed673c687934dab55431a0c8dd6caae54147dbc250cbcb9a0e19"
    sha256 arm64_ventura:  "2ff22774008ee2ed524bce4f7965b098aeb043cc53147ff07620cf920fd4b7e3"
    sha256 arm64_monterey: "c68a651c58974b8a9042c8abcaccbc8d906153b04b1f38f89bb41af50db0ccce"
    sha256 sonoma:         "3e36a3c0687512030f57f958d52e0e1c2c3ee9da09adbc32687f7506cf94494a"
    sha256 ventura:        "0c010977e5701217127383ed6bf148849ed716670c20a3151798b8d9cf7bef1c"
    sha256 monterey:       "bb8f0e3efc67d6d251ce1fb8cd6cfcf8fcdf5812169975568d45a2e546b59610"
    sha256 x86_64_linux:   "7271f370ad1c4d14313291eabf69e83900f1ec99ef869d71cabb4816853852f0"
  end

  head do
    url "https://github.com/FreeTDS/freetds.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
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
