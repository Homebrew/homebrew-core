class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.4.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.4.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.4.tgz"
  sha256 "d51704e50178430c06cf3d8aa174da66badf559747a47d920bb54b2d4aa40991"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6a5fb0e344d7955370211b0fbb5755b6151d60fe15997c7a72d672dbc2719eeb"
    sha256 arm64_monterey: "a90061f1562e0eb87225b3cc22622d9914fa6e5e8d9f2b663c2c0230c81a95e8"
    sha256 arm64_big_sur:  "bc896f598b9e18536f920d277f2d437cd90ed60862f8953050f954a5448d788c"
    sha256 ventura:        "773a9cb06b5669cb6c459c17730bcf8868026faa87cd24be9f1a599db0b36de5"
    sha256 monterey:       "7f84cf3b8e7c62fde66b2f7ddc119aa3a6ba954a1d860af6f302d24014d4e1fa"
    sha256 big_sur:        "86123391f0ceb8bf10c2a18cb01a449b7a920db356fdcf7de676a9081a97f3ec"
    sha256 x86_64_linux:   "67954b08e3cc04b58c58c2169789a73517ae634da2820130cf547d96cd37a7b3"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

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

    if OS.linux? || MacOS.version >= :ventura
      # Disable manpage generation, because it requires groff which has a huge
      # dependency tree on Linux and isn't included on macOS since Ventura.
      inreplace "Makefile.in" do |s|
        subdirs = s.get_make_var("SUBDIRS").split - ["doc"]
        s.change_make_var! "SUBDIRS", subdirs.join(" ")
      end
    end

    system "./configure", *args
    system "make", "install"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, Dir[etc/"openldap/*"]
    chmod 0755, Dir[etc/"openldap/schema/*"]
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end
