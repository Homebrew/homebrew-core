class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.7.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.7.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.7.tgz"
  sha256 "cd775f625c944ed78a3da18a03b03b08eea73c8aabc97b41bb336e9a10954930"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "586762c2bc4dc3ac9c5959009af103ca4d46309c073de7b9da33ad8ec6767e01"
    sha256 arm64_ventura:  "0bb2ff7967bb92f0dd7de90360eb1544931f44559acdaf8499255f3e971a1a1f"
    sha256 arm64_monterey: "3b129f7922a3942d2044d74333cb138d81c3d424254dfdfd5fcbbe4a0f5200f0"
    sha256 sonoma:         "93641ee79dc64412d56d7cd363b8b7f574713a36c4378ae87dd7afb564428fc3"
    sha256 ventura:        "82787c552d0b75a406efb2739ecb42666b1aefeeecf297cf3ce923b6a9ad2aaa"
    sha256 monterey:       "53db644f20f3a1bae71ddecc65366c461b9e64a8816e1b75f81e3c3573055470"
    sha256 x86_64_linux:   "f251004321722f41e9d53b49539c24a7116d8f297969822134e2cdb06c696089"
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
