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
    rebuild 1
    sha256 arm64_sequoia:  "fb6f2aaa1bd42cc3a1f66b2734eb142b5d7720d7ee3f4fc4988cdbcacb94b572"
    sha256 arm64_sonoma:   "33521852182643bef11ec36f2b8a135fb1726156216b8aa7ade41f7d0f54896a"
    sha256 arm64_ventura:  "2dfde5f498579296c4b696ee625832f25a8c199be4101a84513f2ea32bd20b96"
    sha256 arm64_monterey: "789b56750fdced7cb966215496bbc9645c3379b36b7fd033ddac213480a54b42"
    sha256 sonoma:         "fa1f05f6585b701568b83b2b8fd17dcae9202cad5d1bafde3ead076c9a9b0544"
    sha256 ventura:        "aef11fca0e5edd30a40482958ad3ef0ed6cba88cb450403d6c7ec7a20b88593f"
    sha256 monterey:       "225d96d3d691885770a75f327457b0a6480cdbebba506e96deb669bbbbf26bf6"
    sha256 x86_64_linux:   "50b84d04c9adf4ea658519cdc158a68aa264300bdaf290675010529d6d72e6ac"
  end

  keg_only "conflicts with Kerberos"

  depends_on "bison" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "flex"
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@3"

  uses_from_macos "perl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"perl5/lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/perl5"
      system "make"
      system "make", "install"
    end

    ENV.append "LDFLAGS", "-L#{Formula["berkeley-db@5"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lmdb"].opt_lib}"
    ENV.append "CFLAGS", "-I#{Formula["lmdb"].opt_include}"

    args = %W[
      --without-x
      --enable-static=no
      --enable-pthread-support
      --disable-afs-support
      --disable-ndbm-db
      --disable-heimdal-documentation
      --disable-silent-rules
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
