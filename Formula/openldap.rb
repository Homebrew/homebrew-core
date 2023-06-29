class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.4.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.4.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.4.tgz"
  sha256 "d51704e50178430c06cf3d8aa174da66badf559747a47d920bb54b2d4aa40991"
  license "OLDAP-2.8"
  revision 1

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c3f63569a2f1b69f309900e1121203bb8d9dcd4ce74c919fe866bcbe501b03c4"
    sha256 arm64_monterey: "379aad8019a12a749d42b373a58dec45aec5f1dfb7263ef741f10ab4f9e20d38"
    sha256 arm64_big_sur:  "1d348d5dd41704b97454d209792841f9734345bce7c4e3c0c3a9c07cd7216071"
    sha256 ventura:        "7e93a3f5357cf20fd71d98611a68a1225303705f61882be3ab04386deae30495"
    sha256 monterey:       "b5eddf6a15187aa0a289e50f75b3448fabd37790d7b02b75bde690ad0a314114"
    sha256 big_sur:        "e05a924272d44ac5a23b47188a8082f0622e0baa9819756e4dc9f750ac84e6d4"
    sha256 x86_64_linux:   "2ddc12af9582a9c13100d43e4de58dda1fa462ac333f85261952f218ed07cae7"
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
