class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.6.0/heimdal-7.6.0.tar.gz"
  sha256 "afb996e27e722f51bf4d9e8d1d51e47cd10bfa1a41a84106af926e5639a52e4d"

  bottle do
    sha256 "e0aad0685750590e7c94e94c66dd83e145ae707136a81c7d57f9eb03959722e4" => :mojave
    sha256 "5b461217a467645afd1653bbbbb0202e9d39b5748ab7e2d5e1566006497a00bb" => :high_sierra
    sha256 "ffd6e2ac9328dda17a9614aea905f05e879e9184ec94c7bdb62b14c90267547e" => :sierra
    sha256 "011cd9adbc85589034f69ea15a7cd85c60561792f5366e3d977732a9ef076320" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "openssl"

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.02.tar.gz"
    sha256 "444a88755a89ffa2a5424ab4ed1d11dca61808ebef57e81243424619a9e8627c"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "-L#{lib}", shell_output("#{bin}/krb5-config --libs")
  end
end
