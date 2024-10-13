class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.8.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.8.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.8.tgz"
  sha256 "48969323e94e3be3b03c6a132942dcba7ef8d545f2ad35401709019f696c3c4e"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "623ddc86e72704e5a7f5314befd075a3cb54e9df4af9c642b5c13c315a0baec5"
    sha256 arm64_sonoma:   "4c412f0de4d43928958127a53299a1ae73da1f9bbc47f1560a3bd946a4919a5a"
    sha256 arm64_ventura:  "6e1ed35e3e324539f4cc112d7f3d24aa36c550756e6ea42bad8ed81299ce0171"
    sha256 arm64_monterey: "0a90d388c85985489af2bc6fc77c868d71460098549b2bbb83f5138e32b057ec"
    sha256 sonoma:         "6ce29ea406a5839bab5071a1844b49d4df905cfa88a9868673b03290d43f263b"
    sha256 ventura:        "02d09a4818dc91507c4ea8306459dabb331b983c573c2f2855ecb3c7afac3e32"
    sha256 monterey:       "f70846e774dd546e9514ada3057e7f8b550521c5301908f547b8a4cc435a59db"
    sha256 x86_64_linux:   "8b49f676a7948a38bdc1b8089400628c95502330a0d2569635d4741bce3d1e53"
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
    inreplace etc.glob("openldap/slapd.{conf,ldif}"), prefix, opt_prefix, build.bottle?
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
