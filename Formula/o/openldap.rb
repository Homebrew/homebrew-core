class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.7.1.tgz"
  mirror "http://mirror.koddos.net/OpenLDAP/openldap-release/openldap-2.7.1.tgz"
  sha256 "253db80f301258ea69cda1184766d57395b836aaabf41157eb0316eb0fac1341"
  license "OLDAP-2.8"
  compatibility_version 1

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "486fb6411c6d1f7b2e56140626d469d757ab0e8588ff0e0b110dbc88044a3166"
    sha256 arm64_tahoe:       "99520f460581c5d6108288ba532a9d00b1d6bc71a5a2e3160eaf4a3c7259d195"
    sha256 arm64_sequoia:     "6a42b4fc9c8d2387ba1a1db5cbd9a09b96e2513b979bee5c6cc474b21610a8f7"
    sha256 arm64_sonoma:      "606c6f7500e31f9410fb75d91f8f1cf4e7169e44a9feb3a9b26686bd8629c76e"
    sha256 arm64_linux:       "9cb41774eb29e9e495567734a385149815afa2026a46ad5346f16e0ddba1a086"
    sha256 x86_64_linux:      "e4988f982ddd7d6cbd4ae1a75f214acd16503627ba3869127ad7953c5493f325"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build
  uses_from_macos "cyrus-sasl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  on_linux do
    depends_on "util-linux"
  end

  fails_with :clang do
    build 1600
    cause "needs C23 label-before-declaration support, completed in clang 18"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    type :unofficial
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
