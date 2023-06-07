class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.4.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.4.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.4.tgz"
  sha256 "d51704e50178430c06cf3d8aa174da66badf559747a47d920bb54b2d4aa40991"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "f503cb37d9419959e0739bfe7b960c91d50f644b29d76b153902a015cd751f14"
    sha256 arm64_monterey: "ede5c0fe3c1c9f534a50c07ad3063c2b213761f33a34b8c118cc6d38201b46d4"
    sha256 arm64_big_sur:  "02e3369d6fc602fe71a253c331b8e22c3c0b0c2fbcb369cddb24c75fef8f4167"
    sha256 ventura:        "b4a9a392b4fd8ca05a07f9558191959117c4b4f0016bb5b80d0d7b045cb062f6"
    sha256 monterey:       "aac550094125b342a299887415d17f9009a9c4219a2fd9f0e4a059ad8e920003"
    sha256 big_sur:        "032b7cd95fc2e055df75a235c987b24d7ce3b104eef8938a56c620d8fc677634"
    sha256 x86_64_linux:   "0b678bbcef3879aa05a4f84c3997a18fccc3a083a9ccb036fbc69fe3ecc3e8cd"
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
    chmod 0755, etc.glob("openldap/*")
    chmod 0755, etc.glob("openldap/schema/*")

    # Don't embed prefix references in files installed in `etc`.
    inreplace etc.glob("openldap/slapd.{conf,ldif}"), prefix, opt_prefix
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
