class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.5.5.tgz"
  sha256 "74ecefda2afc0e054d2c7dc29166be6587fa9de7a4087a80183bc9c719dbf6b3"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "8b66ccd0a169b6f2ecdff69946a458d404fcb34fe2d4171f83530e9f66318c3f"
    sha256 big_sur:       "4c98f6da7b2d08b95410c87a6a378dea1299bad5f44dbf2583f468495e05da30"
    sha256 catalina:      "79ff7be2a569b51a09ee8c6239c36bf55b7f5553cae099550471d930b08a18b7"
    sha256 mojave:        "82aef6314649c3b0f5b32085976caa677e230829b4dbdca77fcf143182b48209"
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
