class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.7.0/heimdal-7.7.0.tar.gz"
  sha256 "f02d3314d634cc55eb9cf04a1eae0d96b293e45a1f837de9d894e800161b7d1b"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/heimdal[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "264193a55098d1bed1a757b6cba27e314a6f7ded203753661695287e78cf9661"
    sha256 arm64_big_sur:  "4f9d35b8518b4dc64f3995d55a8afbc532a69d3129723ecda4afcfa874c4f371"
    sha256 monterey:       "28a1bb65ff722bc70c0b43c87095eaa9a7c3691385cdad1c1a02a6cc81c68e1d"
    sha256 big_sur:        "8908f59611a4a8140e47e938019691611c5e2c168ae0df3060e3729f941dceab"
    sha256 catalina:       "dc1ffe6fcbf8522c3c1720c44311fb6f183dfc2cf566a7a5ce0bc7064efa5db5"
    sha256 mojave:         "8458b10c77f8db149e1c6853aa709c65551b2c00033ddc447e67b8d90665faad"
    sha256 x86_64_linux:   "27274f62e9071aed890bcf71a83a7ecc8362904432e9e04734f9a0d86fa8cf99"
  end

  keg_only "conflicts with Kerberos"

  depends_on "bison" => :build
  depends_on "berkeley-db"
  depends_on "flex"
  depends_on "lmdb"
  depends_on "openldap"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.02.tar.gz"
    sha256 "444a88755a89ffa2a5424ab4ed1d11dca61808ebef57e81243424619a9e8627c"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
