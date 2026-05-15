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

  bottle do
    rebuild 4
    sha256 arm64_tahoe:   "a67b0f0f1d02fff96fa17c46bbc75997198259f1ed3ff80c8e6a40a11cf48966"
    sha256 arm64_sequoia: "69306dd51e40e93e603ff444164f32ca5d486255b6be42c7b9503e5b1a84b9a7"
    sha256 arm64_sonoma:  "ddb9f3ef8a11d7008249605c47bf53e01910ce76b1814f961e88edd25308f3ce"
    sha256 sonoma:        "8a0d6d032dfac9d335c2840e59833c6e1620ff936b9b9451acb4ac304c5fe55e"
    sha256 arm64_linux:   "029e7264724697de827f4bfcdf2ea3f1e0f340da3d1666185f2380e8bc4b682b"
    sha256 x86_64_linux:  "9ec9421a895c48bbee087eb572cb4e6fe90e061306b5c0153ce41a06833cb6a3"
  end

  keg_only "it conflicts with Kerberos"

  depends_on "pkgconf" => :build
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  # TODO: Remove in the next release
  # https://github.com/heimdal/heimdal/commit/f62e2f278437ff6c03d2d09bd628381c795bba78
  resource "JSON" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
      sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
    end
  end

  def install
    if OS.linux?
      odie "Remove JSON resource and corresponding build!" if version > "7.8.0"
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
      --disable-otp
      --disable-silent-rules
      --disable-static
      --with-openldap=#{Formula["openldap"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-hcrypto-default-backend=ossl
      --without-berkeley-db
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "-L#{lib}", shell_output("#{bin}/krb5-config --libs")
  end
end
