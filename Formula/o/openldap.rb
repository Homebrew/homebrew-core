class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.7.0.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.7.0.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.7.0.tgz"
  sha256 "9e86f37da375aa948a1b478dd76fe87b02090e47c21facae19223588e3407922"
  license "OLDAP-2.8"
  compatibility_version 1

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4bb40d8d714d937604d04b14118c147d1365852b7c3007a5a0bbcab8b4ca9410"
    sha256 arm64_sequoia: "bfbe567a6248b92bd3b60d86190ddbd26f49145c0d63d3272e0208ea0436cf7c"
    sha256 arm64_sonoma:  "48ec4f171be8555951b1a0abf35598530ea44c14f4faa1f9d1157a12e5a3aa67"
    sha256 sonoma:        "ee2a37853fc33298bb5133d8c9ffce05848484d1fd632e5ab61e229d0ee6e9a4"
    sha256 arm64_linux:   "6d6959866e6dbc80aef7d9ba7e46250dc7d1659b82a9fc1d4fa6d0580aa51937"
    sha256 x86_64_linux:  "f720a0f32095519560fe769c978a53d4f5b701bc6c9d06a1c013fc23c4087162"
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
