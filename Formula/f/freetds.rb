class Freetds < Formula
  desc "Libraries to talk to Microsoft SQL Server and Sybase databases"
  homepage "https://www.freetds.org/"
  url "https://www.freetds.org/files/stable/freetds-1.4.17.tar.bz2", using: :homebrew_curl
  sha256 "3f70a8455eb3a2902d4039ad91b934a348ca1eee23a4a92a3de0824905a7d1a2"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.freetds.org/files/stable/"
    regex(/href=.*?freetds[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "20bbf064b011625b140f9ff2a5cc5993a7dbdf2188bb4ecad8811db0e8f59166"
    sha256 arm64_ventura:  "383204dec3cebf7688b2b4b6d52c445d0557384e8106bd88b3ddbacd53857358"
    sha256 arm64_monterey: "1e898d0812ec376a4942465388ec984ba1699b752c6d010c578dc8127a10066e"
    sha256 sonoma:         "659965cbbd58645c4428515c9ea10cc62a325e391949a7d851e30825479e2e98"
    sha256 ventura:        "2bbe00e893122c4694bcea9bbf6d346a70e78f4db8f42c425d98284e1f123fdc"
    sha256 monterey:       "bb320c78d0372793aa7db8df82b0794b5a7b41a0edee7d8b38f726cd098c56ac"
    sha256 x86_64_linux:   "aac6a3703b0e84b7ff7bb5f52cdb45801ef10e7ccf344ecf00c7907b80a8bf41"
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
