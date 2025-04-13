class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.9.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.9.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.9.tgz"
  sha256 "2cb7dc73e9c8340dff0d99357fbaa578abf30cc6619f0521972c555681e6b2ff"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d46daf11a6c5a4dc952cf9bb6eb2e9fd9b8d413939052ceee114108b15584adf"
    sha256 arm64_sonoma:  "f7a11d5195b4e1426d6690470ccfe7dee9f7e8bc524b9af7519b97e67f10346c"
    sha256 arm64_ventura: "f9f450125e7b6548a81b0d9f83babf08409a6cbe80d40617b8c3f256261a2a6b"
    sha256 sonoma:        "1c584b75365da368f6aec0830d6e5cddbdb1dc5fb7a16a818c299574c173f904"
    sha256 ventura:       "542bbb6594a79baf910a87c265ae57d33d6cd0dec19ed536596ab26b2131b623"
    sha256 arm64_linux:   "3fca9fbb6de4c3c9115041de0adef3c683f51e347e8af2990bba5c37e687c418"
    sha256 x86_64_linux:  "f4ae258483526f378f60511ec5ecb77f3aeea3819ac2b9d369d6c76d2d74c563"
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
