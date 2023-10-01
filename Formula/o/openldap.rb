class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.6.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.6.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.6.tgz"
  sha256 "082e998cf542984d43634442dbe11da860759e510907152ea579bdc42fe39ea0"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "0664e43cdee625e336007730038b596e5cbae9c66036289cc1625052f0c37af4"
    sha256 arm64_ventura:  "29426f6dd15964b20f8561f9f0a7a332a80086a0b480ac739719213c76f2d5e9"
    sha256 arm64_monterey: "7812d6a2e9faa260f918bd39ef8a0e6cb37063b4f9bac67449e7e9bf8bda6a70"
    sha256 arm64_big_sur:  "989d4f6ec3b7caad51088b0afd70b7544ec2bb210d3fc6cd845252e776884289"
    sha256 sonoma:         "db3357512f13bcc05b9d02a03136e10d04f952c8e95dff3e593a32cb197e10ed"
    sha256 ventura:        "03c932365fcfc8e8523c82a5da61cb22eb8341a35a2c959cf27468657b134f92"
    sha256 monterey:       "b68dd6afb59524ff8c7711b2d2c77227d6c7aa1f3994ca3cf0071d748bdb9c13"
    sha256 big_sur:        "c2f581d225a0f1f40f285734b1d399068b4cbda11e5d1042f8ab4b3672e55325"
    sha256 x86_64_linux:   "161684fd77821834cc9a918a8e9b01636f5f6c5ce92a2d7abf2c6628d71a8100"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

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
    chmod 0755, etc.glob("openldap/*")
    chmod 0755, etc.glob("openldap/schema/*")

    # Don't embed Cellar references in files installed in `etc`.
    # Passing `build.bottle?` ensures that inreplace failures result in build failures
    # only when building a bottle. This helps avoid problems for users who build from source
    # and may have an old version of these files in `etc`.
    inreplace etc.glob("openldap/slapd.{conf,ldif}"), prefix, opt_prefix, build.bottle?
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
