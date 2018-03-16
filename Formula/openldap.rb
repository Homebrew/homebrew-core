class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.45.tgz"
  mirror "https://gpl.savoirfairelinux.net/pub/mirrors/openldap/openldap-release/openldap-2.4.45.tgz"
  sha256 "cdd6cffdebcd95161a73305ec13fc7a78e9707b46ca9f84fb897cd5626df3824"

  bottle do
    sha256 "de441b2b17c16c76cc8883b4d3222f79985dc60013729a679a6917ce857a2682" => :high_sierra
    sha256 "809a58277010241b76cb9474b303d55540ae71c59ef401ece495f6b5ab57949c" => :sierra
    sha256 "645727db7cc901fa3493c66c06e55ecce778846961874deff6b1a4687aa04b35" => :el_capitan
    sha256 "ea5d0a84b570b85c6711a5c99dd12f2ba6811c7b3515ddd1b1d1761490a8fa81" => :yosemite
  end

  keg_only :provided_by_macos

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

    args << "--enable-bdb=no" << "--enable-hdb=no" if build.without? "berkeley-db@4"
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
