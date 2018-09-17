class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.46.tgz"
  sha256 "9a90dcb86b99ae790ccab93b7585a31fbcbeec8c94bf0f7ab0ca0a87ea0c4b2d"

  bottle do
    sha256 "ef50717024faa28ac0818d737c128d54648ec742e47ad0852533034b8ec37a72" => :mojave
    sha256 "2094541bf0f0b265e6cc1518aa5ac223b75834f0aa12bec8e00b6c9469e9b5d9" => :high_sierra
    sha256 "f8912be8188c34e398b61ff7c1f922eb1d4294b21555de55b0763f8424cd0eaa" => :sierra
    sha256 "9fe6bd03378eb760c4253a36d3f41f5403e117fa8abe4e263a0190310f65a6de" => :el_capitan
  end

  keg_only :provided_by_macos

  option "with-sssvlv", "Enable server side sorting and virtual list view"

  depends_on "openssl"
  depends_on "berkeley-db@4" => :optional

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
