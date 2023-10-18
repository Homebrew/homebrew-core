class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.8.0/heimdal-7.8.0.tar.gz"
  sha256 "fd87a207846fa650fd377219adc4b8a8193e55904d8a752c2c3715b4155d8d38"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/heimdal[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "8b480f9df4e9202f563a2d9946ff32ee8f32396ddbc203c426d6571444b943d4"
    sha256 arm64_ventura:  "3cc28db88f119ee29956332ee3bb187c3aa7b8248ff1a455a85575568bf0118f"
    sha256 arm64_monterey: "e9afb91c49a8763636ee2ba0e278dc41137cd0ebe94d7b33893d9ee4cebb0277"
    sha256 arm64_big_sur:  "0919ca038055abca1ed8454d85b394dd0448c7a8822605bdec25e67d3f620de8"
    sha256 sonoma:         "71b25e02df1ba68d4c27654415424ed02d7d87a56b5bfc84922593f7cbad0ff0"
    sha256 ventura:        "13c389d268721a6b423b6c0aea6e5d9a97b5037171cc72452f59e78ae961e453"
    sha256 monterey:       "bea74d1460429c73745f8d2459fda3788d628fa5a819185e6d41cc93b55b37d9"
    sha256 big_sur:        "e14aaa2d7953fae00c33ea0fb8faf17f87b35a0ca9158436b7bb327e7a23dc02"
    sha256 x86_64_linux:   "399e2dc4b8832a8c28b967f5bb24cb9809c5bbcc60b816f1c5c23c0853c32bae"
  end

  keg_only "conflicts with Kerberos"

  depends_on "bison" => :build
  depends_on "berkeley-db"
  depends_on "flex"
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "python@3.11" => :build
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    ENV.append "LDFLAGS", "-L#{Formula["berkeley-db"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lmdb"].opt_lib}"
    ENV.append "CFLAGS", "-I#{Formula["lmdb"].opt_include}"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --enable-static=no
      --enable-pthread-support
      --disable-afs-support
      --disable-ndbm-db
      --disable-heimdal-documentation
      --with-openldap=#{Formula["openldap"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-hcrypto-default-backend=ossl
      --with-berkeley-db
      --with-berkeley-db-include=#{Formula["berkeley-db"].opt_include}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-L#{lib}", shell_output("#{bin}/krb5-config --libs")
  end
end
