class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.10.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.10.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.10.tgz"
  sha256 "c065f04aad42737aebd60b2fe4939704ac844266bc0aeaa1609f0cad987be516"
  license "OLDAP-2.8"
  revision 1

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a1dc03b12f5d087bf8eca0c017483a45548a88ad62e27e0c0efe499f19cf57ff"
    sha256 arm64_sonoma:  "fc1c7897033c6869b7bcc0e9e7589c7e2dc1bcda9f1939bc571f6afc9586b97f"
    sha256 arm64_ventura: "2940262081277489fbb0b6187269efb4dca69ad6000b1793ce2e67a8fcce5513"
    sha256 sonoma:        "6360ceeaf23775210ee3c9f739ff8d7b3cd83b2dfce7bf7ae4cd69065b3ec544"
    sha256 ventura:       "f3da0ae98808e034485d22f56185b01715e544387d6d5a61df4f7cd4dadb2930"
    sha256 arm64_linux:   "56958d2700c221fd98383fc04078a18e3f9b28afae795c2b15b0cb5fcba10b62"
    sha256 x86_64_linux:  "79ace347f02583cfe9e64e4e28b96a965b5b4a96d98db2ce0d746be4ad5da3b9"
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
