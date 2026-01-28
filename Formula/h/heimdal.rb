class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://github.com/heimdal/heimdal"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.8.0/heimdal-7.8.0.tar.gz"
  sha256 "fd87a207846fa650fd377219adc4b8a8193e55904d8a752c2c3715b4155d8d38"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",    # lib/gssapi/mech/
    "HPND-export2-US", # kdc/announce.c
    :public_domain,    # lib/hcrypto/libtommath/
  ]
  revision 1

  livecheck do
    url :stable
    regex(/heimdal[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_tahoe:   "494784674bf30f21015e779c12e571f66e440951a5d837a9b9fd3ed33454775b"
    sha256 arm64_sequoia: "b98ef6f977b5c577651f8b4d14ada315d11eeb3155cdc1b2d80351cd21bcafb7"
    sha256 arm64_sonoma:  "848f372439fb91e3758681e529350b9fcbeebae0e5a6100a114c124ca0ca7f9d"
    sha256 sonoma:        "da71a50cfc7717bbd57c8c99d50c21ef705a95f14bf332380a932334d543edbe"
    sha256 arm64_linux:   "db3a0eee434231a275600a3aaa8da18416cfc1d467c8a31631d0f8a8db03ae56"
    sha256 x86_64_linux:  "938a68365f4def1622b54fbb92b83d6c444e8cf89c3bc693a935eeeea7e8109c"
  end

  keg_only "it conflicts with Kerberos"

  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  resource "JSON" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"perl5/lib/perl5"

      resource("JSON").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/perl5"
        system "make"
        system "make", "install"
      end
    end

    args = %W[
      --without-x
      --enable-pthread-support
      --disable-afs-support
      --disable-ndbm-db
      --disable-heimdal-documentation
      --disable-silent-rules
      --disable-static
      --with-openldap=#{Formula["openldap"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-hcrypto-default-backend=ossl
      --with-berkeley-db
      --with-berkeley-db-include=#{Formula["berkeley-db@5"].opt_include}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "-L#{lib}", shell_output("#{bin}/krb5-config --libs")
  end
end
