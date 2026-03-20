class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.13.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.13.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.13.tgz"
  sha256 "d693b49517a42efb85a1a364a310aed16a53d428d1b46c0d31ef3fba78fcb656"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a7e2d742e8b2d70ab77446b4a596bb10f7efd2ee0589f2eaeec24a37e4c2744a"
    sha256 arm64_sequoia: "28c2a98c69c5e64adbbbf2da4f3ff4cdea5169277679e26cb5e721c0d9dca513"
    sha256 arm64_sonoma:  "d1b5d4cf45357617d67c11d4e8830563cca78fff27436ab39030809ff5facf55"
    sha256 sonoma:        "e2041deb3ff2c7d88578218c3a414f9b870c0f3d3f8a111909ef1c0bdff3cbaa"
    sha256 arm64_linux:   "5de6229ea5d0fa4844d49d256ad34664b1b0295f8f3a773b78b2fcd32938c737"
    sha256 x86_64_linux:  "5a958deb06792794bc4ccbca62276d85998cdde566c517d55c127935927e0bf7"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build
  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "util-linux"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
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
      --enable-sssvlv
      --enable-translucent
      --enable-unique
      --enable-valsort
      --with-cyrus-sasl
      --without-systemd
    ]

    soelim = if OS.mac?
      if MacOS.version >= :ventura
        "mandoc_soelim"
      else
        "soelim"
      end
    else
      "bsdsoelim"
    end

    system "./configure", *args
    system "make", "install", "SOELIM=#{soelim}"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, etc.glob("openldap/*")
    chmod 0755, etc.glob("openldap/schema/*")

    # Don't embed Cellar references in files installed in `etc`.
    # Passing `build.bottle?` ensures that inreplace failures result in build failures
    # only when building a bottle. This helps avoid problems for users who build from source
    # and may have an old version of these files in `etc`.
    inreplace etc.glob("openldap/slapd.{conf,ldif}"), prefix, opt_prefix, audit_result: build.bottle?
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
