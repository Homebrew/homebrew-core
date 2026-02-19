class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.12.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.12.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.12.tgz"
  sha256 "1716ad779e85d743694c3e3b05277fb71b6a5eadca43c7a958aa62683b22208e"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8cb64538e7047125ebed0c6e4c3cad8faab9bd88b9c9c7619c2a86df7c61d06c"
    sha256 arm64_sequoia: "9ac2a75ba7526cf1e674729654a0aeb01b689e365e6d3dfe805a6f1dc709186e"
    sha256 arm64_sonoma:  "3783fea9b9faeaab9695e1e8119cc35e57cd05752049f29a4e4f5ce59f2eeac7"
    sha256 sonoma:        "49334307f6719cd0beb84944ff4a909cca9d138f63729e1689ed344de9e5545f"
    sha256 arm64_linux:   "b84940413640e188179bf85dbf1435402299f3d9c37e6690bfe17b66dc009328"
    sha256 x86_64_linux:  "1c9d3e5c1c68949711f2a272a420a1e44f6451fbd42a7fe47ed6ca966f7365d3"
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
