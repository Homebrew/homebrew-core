class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.10.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.10.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.10.tgz"
  sha256 "c065f04aad42737aebd60b2fe4939704ac844266bc0aeaa1609f0cad987be516"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "90749053fa49720027fec10a7f6b69d12e3a7aa2c319fed0c9021ce4a1ee5873"
    sha256 arm64_sonoma:  "8d4319c2a4e33ded3d0650b1e9bd56f4e087a3c72dda53aa1e7fc1c5747dbd93"
    sha256 arm64_ventura: "3f6ac8d8010ce41c011a300b68a93ada298fe35f1c1577f1d9413c2e892d3d06"
    sha256 sonoma:        "dbfb4021fc4b5b3df381c2ec339ed0801952b1d93728152cc30edf6e3e8da1ac"
    sha256 ventura:       "0cca5d539102430ce70d06b5956b6cc9b658a495edb3c7abb13582872f171daf"
    sha256 arm64_linux:   "dd8990617d2d310cf965ff185b405d0b903860b2b535d45d3ddfc6409dd5fa97"
    sha256 x86_64_linux:  "c618d0eb76c5e2cf57846bd6be286018e00da7eb37f5a5b3a6d22ff0ed7885d9"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "mandoc" => :build

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
