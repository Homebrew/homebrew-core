class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.8.0/heimdal-7.8.0.tar.gz"
  sha256 "fd87a207846fa650fd377219adc4b8a8193e55904d8a752c2c3715b4155d8d38"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/heimdal[._-]v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "2a26a718345cbf16201908464eabc918470312b9490b411160d044ca91fffeda"
    sha256 arm64_monterey: "469605c086a6f466b383c621b9696a01f506be578c47a89f8afb6627ab799979"
    sha256 arm64_big_sur:  "817169ac078417ff4cb1e3a6f2c8b06f0d13033ac8498416125db75eaed29d9d"
    sha256 ventura:        "1a6f53d8e4629ef7b0cf5b73797e0c2121e7b7cfcc8d8c86028d990d3a6831cc"
    sha256 monterey:       "083a6661b4cb4c6d121b5627f440bfa733d5b0b86d4ff547d648888eaa2a4da2"
    sha256 big_sur:        "34fb4389ad538efbbf671e42b20a9aafd503ce2cdc38ca8437d87d42bdac0127"
    sha256 x86_64_linux:   "239f40e6405e0ac3231537a89872a94610d07e6c8e6324a593b55404b3c52e55"
  end

  keg_only "conflicts with Kerberos"

  depends_on "bison" => :build
  depends_on "berkeley-db"
  depends_on "flex"
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@1.1"

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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
