class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.50.tgz"
  sha256 "5cb57d958bf5c55a678c6a0f06821e0e5504d5a92e6a33240841fbca1db586b8"
  license "OLDAP-2.8"

  bottle do
    sha256 "c0f1fe7a472cba83a584bd574ba2a4d8e04b73fac95259855ee8697359f7e117" => :catalina
    sha256 "b4273ace070b3f6afb965b0f2c9d43524a38d1521b55febe84833586a5d773fb" => :mojave
    sha256 "fe64b6a62c8fddfa647f8e48ad233ee09514cc0bc7ba43058b85b0809e4cfab2" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

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
