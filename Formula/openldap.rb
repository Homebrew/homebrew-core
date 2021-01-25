class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.4.57.tgz"
  sha256 "c7ba47e1e6ecb5b436f3d43281df57abeffa99262141aec822628bc220f6b45a"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "7d305b33a411e3d20524b79e69ebb355b14e9514a10371f1426b450c4166ae97" => :big_sur
    sha256 "a54e8979251114f78f1edb64668a6aaca413653e7c648b8a5cc13c675a710c42" => :arm64_big_sur
    sha256 "1fcdd72cf7619ea2c79055357f8e1a600e4758d04f2233160381316bf64b0659" => :catalina
    sha256 "6eb20ddb58b95eb2e7523cd5e61dfcd01f7210dacba0659374f60bc0e94a2aec" => :mojave
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  on_linux do
    depends_on "groff" => :build
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
