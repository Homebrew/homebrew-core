class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.5.8.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.5.8.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.5.8.tgz"
  sha256 "366ea1c3b24202de4481978b632128c0cfe4148d4ae13cabf93a1f38c56472dc"
  license "OLDAP-2.8"

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "dd91932d974df0d563517013b8986f85757cf853191145b450f9ad867a3f03a6"
    sha256 arm64_big_sur:  "5618dfec3328a4b061a688289e475eed1355daec819e72bbaa3fb8dd93251005"
    sha256 monterey:       "1542fa4acb76cdf7160d00d652f5e409ea6716449052a3dfa7ab75a9331f9768"
    sha256 big_sur:        "c3cb199829c328e2afe869043b22181ff74993769785791be04cf099927168dd"
    sha256 catalina:       "37b71c03a6915a25ef1fcb66c1a1089f5df3b34af9fb121f7b45703582e16c19"
    sha256 mojave:         "071842e1a32af906ee4d9507271444902d3a288b7e9dd238da40f0bee99b84d9"
    sha256 x86_64_linux:   "350e6f421803d8b6cb566d728f991450da7f52f64865f679394ec050b080a206"
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
