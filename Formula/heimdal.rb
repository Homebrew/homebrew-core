class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.6.0/heimdal-7.6.0.tar.gz"
  sha256 "afb996e27e722f51bf4d9e8d1d51e47cd10bfa1a41a84106af926e5639a52e4d"
  revision 1

  bottle do
    sha256 "1897773e72a05fa2c8f22a81f90abb0775e5aa68d7468308bb9caffe80557b53" => :mojave
    sha256 "ff2203f0e03ab714140ffbea2983ef96f44192181b84523060907fc52b654558" => :high_sierra
    sha256 "0af82e0554ce415d17e27b861b7c596e184207b70cb2189d78612c3d4aa41335" => :sierra
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

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
