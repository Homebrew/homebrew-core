class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.44.tgz"
  mirror "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.44.tgz"
  sha256 "d7de6bf3c67009c95525dde3a0212cc110d0a70b92af2af8e3ee800e81b88400"

  bottle do
    cellar :any
    sha256 "1484ae2607b751144c35f91c8324990d5f6c77d89b6e0023458c53ed9b4b1c40" => :sierra
    sha256 "13c1430be5357dd9ede49fc376ba668d727aca6f4646b14c15609628ad7ae6df" => :el_capitan
    sha256 "0fb583888567fedc05b20a06b956b2387d73ef692a3d350a22e46b7362390f51" => :yosemite
  end

  keg_only :provided_by_osx

  option "with-sssvlv", "Enable server side sorting and virtual list view"

  depends_on "berkeley-db@4" => :optional
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-translucent
      --enable-unique
      --enable-valsort
    ]

    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "berkeley-db4"
    args << "--enable-sssvlv=yes" if build.with? "sssvlv"

    system "./configure", *args
    system "make", "install"
    (var+"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
