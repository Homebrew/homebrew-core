class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.5.7.tgz"
  sha256 "ea9757001bc36295037f0030ede16810a1bb7438bbe8f871a35cc2a2b439d9ab"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "c4d9a59ec4d441285110a2dfa0d67f51f5c3143bae306312f2b452a9f3f48225"
    sha256 big_sur:       "84724691666b037bc57a88be1c76a9ff30c8559c89780fea8cac439f5350e499"
    sha256 catalina:      "b8ab256ce13cd4e4ab969f086cb37dc4a192ed9fe65fd476ff4085d2b29855e5"
    sha256 mojave:        "44112f8f14f19d469c98eecf0c390fa8205e69a14429df199ae86c5b9a835ba9"
    sha256 x86_64_linux:  "b107a8e433dbe115672a023a3b9466f5cbad67a5314cfb9b660627a2d679d360"
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

    if OS.linux?
      args << "--without-systemd"

      # Disable manpage generation, because it requires groff which has a huge
      # dependency tree on Linux
      inreplace "Makefile.in" do |s|
        s.change_make_var! "SUBDIRS", "include libraries clients servers"
      end
    end

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
