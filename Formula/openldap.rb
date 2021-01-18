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
    sha256 "345810c84de13512ecf41b3ff0b606d8e59b093ab6bb3532e2cc3488a76c77fe" => :big_sur
    sha256 "8b395311cd3ab9e08fec534f6d8f21dab159089aed7e73d636e63943da8df41a" => :arm64_big_sur
    sha256 "c51d24181e4291ece30b4ff8504f864bc4e0432a0dc85b64d6f4cac68b4f43dd" => :catalina
    sha256 "8a9151d93ef5d9fe13aefe74b9cbba128524cfa5646d3bafa84b44180ffcba22" => :mojave
    sha256 "517c23bda49065c883a38d4d2ea0b1816860913c0b30013be170a01d3518a824" => :high_sierra
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
