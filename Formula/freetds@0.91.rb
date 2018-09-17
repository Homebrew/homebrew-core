class FreetdsAT091 < Formula
  desc "Libraries to talk to Microsoft SQL Server & Sybase"
  homepage "http://www.freetds.org/"
  url "http://www.freetds.org/files/stable/freetds-0.91.112.tar.gz"
  sha256 "be4f04ee57328c32e7e7cd7e2e1483e535071cec6101e46b9dd15b857c5078ed"

  bottle do
    sha256 "fbe4fd7ae0a297de1d74dc880b4cf188567f7f36d9d4677bb2b8af839da9d6aa" => :mojave
    sha256 "00870a22aefb2a8f0253b6a4657a02675eae56f37271c7142737e8b78cea7b46" => :high_sierra
    sha256 "ab0419c2290e4204524a74de3e652e8fae23b9d29dce793554c38c79a28be947" => :sierra
    sha256 "3e9bfe7bf16e71cc6a68e1296c4af381f40ccb68363edaf94f276393e05d8ac6" => :el_capitan
    sha256 "55b8960ca59ecc738e5973451195da1b4133eb0e31559454e87c5b1f103337bb" => :yosemite
  end

  keg_only :versioned_formula

  option "with-msdblib", "Enable Microsoft behavior in the DB-Library API where it diverges from Sybase's"
  option "with-sybase-compat", "Enable close compatibility with Sybase's ABI, at the expense of other features"
  option "with-odbc-wide", "Enable odbc wide, prevent unicode - MemoryError's"
  option "with-krb5", "Enable Kerberos support"
  option "without-openssl", "Build without OpenSSL support (default is to use brewed OpenSSL)"

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "unixodbc" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --with-tdsver=7.1
      --mandir=#{man}
    ]

    if build.with? "openssl"
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    if build.with? "unixodbc"
      args << "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    end

    # Translate formula's "--with" options to configuration script's "--enable"
    # options
    %w[msdblib sybase-compat odbc-wide krb5].each do |option|
      args << "--enable-#{option}" if build.with? option
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Or fails to install on multi-core machines
    system "make", "install"
  end

  test do
    system "#{bin}/tsql", "-C"
  end
end
