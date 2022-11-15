class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.3.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.3.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.3.tgz"
  sha256 "d2a2a1d71df3d77396b1c16ad7502e674df446e06072b0e5a4e941c3d06c0d46"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "db25c7e317ccf5ca1282b9ab4ef178f3bca979c0d6ace9b03161c97d1699f5f4"
    sha256 arm64_monterey: "d3f0bdb0fdab90601339ec57ad4291aa08907733d40162a7450f3bafd3768e8a"
    sha256 arm64_big_sur:  "9f347097480480f7df1519279a588cd68bf98e7befa11971c803a858843ebc6a"
    sha256 ventura:        "29d558ec118be91f00f44d2f4269edb66ff4bea3107629adb671cbfbfe7beb5b"
    sha256 monterey:       "107f7937af3e60ecf4262b4f60b7da74c38ef55c07c735c3f906f2bdb0067934"
    sha256 big_sur:        "5881d9b771d9296d464a8d2f8e00908e76b31076df50d2c86225a9151ec64a85"
    sha256 catalina:       "542b132bd0ae22ad6ffe2bb2f25f17c1933943ead28791bcf7e53888b48f5de1"
    sha256 x86_64_linux:   "236b263f5d84e1c580380289599cad1719cc8c8b2bb1c78b48578aa139dc1095"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
      --without-systemd
    ]

    if OS.linux? || MacOS.version >= :ventura
      # Disable manpage generation, because it requires groff which has a huge
      # dependency tree on Linux and isn't included on macOS since Ventura.
      inreplace "Makefile.in" do |s|
        subdirs = s.get_make_var("SUBDIRS").split - ["doc"]
        s.change_make_var! "SUBDIRS", subdirs.join(" ")
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
