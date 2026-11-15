class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.7.2.tgz"
  mirror "http://mirror.koddos.net/OpenLDAP/openldap-release/openldap-2.7.2.tgz"
  sha256 "aad731aa22118ff327b9b4ddfc4b6f18ef9476586205da88a532e90940b523d2"
  license "OLDAP-2.8"
  compatibility_version 1

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "74486af11b5ce4964408eb37f00616df44df4d1e97551f678a304f2dda064c80"
    sha256 arm64_tahoe:       "48879a4af02d1a84121f5a6cedd19e4be10610bdadb1906e15bf690553f0cda7"
    sha256 arm64_sequoia:     "f0fcf9aaced28ea804f4caa12aef13966f22b74d51963f98bc757b29dce1cfdd"
    sha256 arm64_linux:       "8f35971652270ae3e08756c7f3dbd87ef426c78567aa54dee073d39eff96f606"
    sha256 x86_64_linux:      "2767f84e88cbba4fcdcef58e23c4cd54e69ac7ba5ad5925ac8d1edc52eea2fb5"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

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

  deny_network_access!

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
