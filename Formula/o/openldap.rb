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
    rebuild 1
    sha256 arm64_tahoe:   "2e201b0ef1eeb3990d14dd4905ecaf36cb6acbb9457093007ed304b97a6a9856"
    sha256 arm64_sequoia: "248a79f1498bbff0644cb1980d1efabf399d71f4251df230b7e6161d14482309"
    sha256 arm64_sonoma:  "e1e547e9f5a91f21715853710892d69d0356947128b15a9ae16c7b69b2c8222c"
    sha256 arm64_ventura: "bacfcb76abf64fb280a1e845abc7ef842aa8ddaafb3c7b1a4b68e7e9cd66161d"
    sha256 sonoma:        "8845255968f6ce00273b24b4ec963913900cd33179ee6a5b8e29b887f84364bd"
    sha256 ventura:       "77370c7be27839f6b1c67b6594ede02919dafe3ce30760eddd033b382b38785c"
    sha256 arm64_linux:   "d6aa23170013b357b634255d980bf589fc5104f38536e99a524ffbdd20dd17e7"
    sha256 x86_64_linux:  "6593c993b1e061f4f5bd11a3a0a98cdb64244d35a12d0787797daaaa9ea4cb47"
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
