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
  revision 2

  livecheck do
    url :stable
    regex(/heimdal[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "eb16f1795d41dd0f207143ffaa38675283e1728c0aa26a61269c98673a099f45"
    sha256 arm64_tahoe:       "d78e8a837942b63912eb6f104f013acc0167ca78476639da885c242616c8e05f"
    sha256 arm64_sequoia:     "d2213331dbce12ec4d3ee75016e6e04a7fecbc20800ba7244e5ab5a64044f4ee"
    sha256 arm64_linux:       "598151937a534334d2fd2052b3c90a8ff61e4b6e1a8eb26d17bda6ff302f8a9d"
    sha256 x86_64_linux:      "e07927309c18c37b64c1ecc7ffe2dddb5e301e928b807795e3886ab393306463"
  end

  keg_only "it conflicts with Kerberos"

  depends_on "pkgconf" => :build
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@4"

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
      --with-openldap=#{formula_opt_prefix("openldap")}
      --with-openssl=#{formula_opt_prefix("openssl@4")}
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
