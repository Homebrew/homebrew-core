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
    sha256 arm64_monterey: "254a9a1b07970313b39d0ba54c56605a5bf41b82a3fb3c2321493ed48bfd15d3"
    sha256 arm64_big_sur:  "6d4d0e83e5b7000e561efd941010e20268882af50499f3ff6f0a4f58fe3d30c3"
    sha256 monterey:       "f3513ae677858f5acd5b6013d6738597c56144df457c31e99b3214e4b1a469bc"
    sha256 big_sur:        "fe5e72040e02b6a74cadd77afba7f3941bc998dfc1b6920b28b4d1775fd98cbc"
    sha256 catalina:       "1576d37223da54d2eadac1248e2a78f9fe395b746b66e60d7986d6ae8751017b"
    sha256 x86_64_linux:   "e6c5c02a4486d6092a469e80001b31f57aa3b170609fe5bd9e63d7973eda0224"
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
