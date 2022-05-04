class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.2.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.2.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.2.tgz"
  sha256 "81d09345232eb62486ecf5acacd2c56c0c45b4a6c8c066612e7f421a23a1cf87"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d7affa175537fa764aa33608d8e0029b1a80764743ef769b3f8cf4be2fd200c3"
    sha256 arm64_big_sur:  "5b312b24c8bbd740a7c7a765cdeb50fbebf305472ae17b8afb90640c9f332ab3"
    sha256 monterey:       "e2d098cbc57f94ddca5121b016350b20737960dc9517d0d46edd259e1bd10852"
    sha256 big_sur:        "a84f34991c1bee01efb067984c3407f4777fc111fa258821698d4ecda71582e6"
    sha256 catalina:       "7ad505e0578547ea2bb4a1cd3bbef466ec4c214d6b5342d2c280685dfc061dd4"
    sha256 x86_64_linux:   "12a1be636f9fb47fb2ab77849e3b16b47272745ebece94b6b396d5ec23788f8c"
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
    ]

    if OS.linux?
      args << "--without-systemd"

      # Disable manpage generation, because it requires groff which has a huge
      # dependency tree on Linux
      inreplace "Makefile.in" do |s|
        s.change_make_var! "SUBDIRS", "include libraries clients servers"
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
