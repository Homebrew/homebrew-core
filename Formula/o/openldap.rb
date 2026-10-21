class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.7.1.tgz"
  mirror "http://mirror.koddos.net/OpenLDAP/openldap-release/openldap-2.7.1.tgz"
  sha256 "253db80f301258ea69cda1184766d57395b836aaabf41157eb0316eb0fac1341"
  license "OLDAP-2.8"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "14db7870f2249738029a8ad3fccf76028b9bc6db7dacde756edfae6734ec020e"
    sha256 arm64_tahoe:       "1c976928f9b9091e0588a9367cefdd8be14ba0ec42d29f9deb4f4a889699da97"
    sha256 arm64_sequoia:     "03bcbc4d521f23a2941917039345cd72fc2a8b663b54e2bae28c006622f904f9"
    sha256 arm64_linux:       "9c973378895f21d3b3560b4517c426a21a85aa15b01977ee5956d498e2b8d1a8"
    sha256 x86_64_linux:      "79191466b270dd3b1cff215db9fc2f1859e044ee5d8a9e2d0a770cb82e870630"
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
