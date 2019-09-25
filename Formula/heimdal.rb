class Heimdal < Formula
  desc "Free Kerberos 5 implementation"
  homepage "https://www.h5l.org"
  url "https://github.com/heimdal/heimdal/releases/download/heimdal-7.6.0/heimdal-7.6.0.tar.gz"
  sha256 "afb996e27e722f51bf4d9e8d1d51e47cd10bfa1a41a84106af926e5639a52e4d"
  revision 1

  bottle do
    sha256 "067b331e7e7122c431c4425eff6ce2a6c4f6e449bb77c17d8da702af271b7af6" => :mojave
    sha256 "0e224122ed2c8e5621b93acde3378b69d40567ca075c50b3d5c4f6ad3c783a7f" => :high_sierra
    sha256 "1ac3c2582de7d1562ecfd685893e599bee38f774b52ba568ea8e0925889fb63f" => :sierra
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
