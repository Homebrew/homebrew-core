class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.48.tgz"
  sha256 "d9523ffcab5cd14b709fcf3cb4d04e8bc76bb8970113255f372bc74954c6074d"

  bottle do
    sha256 "07e1f0e3ec1a02340a82259e1ace713cfb362126404575032713174935f4140e" => :mojave
    sha256 "8901626fc45d76940dec5e516b23d81c9970f4a4a94650bdad60228d604c1b4a" => :high_sierra
    sha256 "6dc84ff9e088116201a47adc5c3a2aab28ffd10dbab9d677d49ad7eef1ccc349" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
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

    system "./configure", *args
    system "make", "install"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
