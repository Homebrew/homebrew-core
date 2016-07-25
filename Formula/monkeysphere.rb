class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "http://web.monkeysphere.info/"
  url "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_0.38.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.38.orig.tar.gz"
  sha256 "6951821d11ad646e6e7651d677bfab8f800fbc52703a0ab9942d03cd13959073"
  revision 1

  head "git://git.monkeysphere.info/monkeysphere"

  bottle do
    cellar :any
    sha256 "57cae3fb443156493dc11a94df356fa89f35ca860d4dc3eae26a63c640c0d41d" => :el_capitan
    sha256 "df552a96f3eed85b8cc0b3e0afc06989cdf3f961daf328d8733f7f0460adbbf7" => :yosemite
    sha256 "ea8547fb15ade2e724337e828dbbd12db90c5d95e2c9d45a88f22eeef278b505" => :mavericks
  end

  depends_on "gnu-sed" => :build
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl"

  resource "Crypt::OpenSSL::Bignum" do
    url "https://cpan.metacpan.org/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.06.tar.gz"
    sha256 "c7ccafa9108524b9a6f63bf4ac3377f9d7e978fee7b83c430af7e74c5fcbdf17"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("Crypt::OpenSSL::Bignum").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    ENV["PREFIX"] = prefix
    ENV["ETCPREFIX"] = prefix
    system "make", "install"

    # This software expects to be installed in a very specific, unusual way.
    # Consequently, this is a bit of a naughty hack but the least worst option.
    inreplace pkgshare/"keytrans", "#!/usr/bin/perl -T",
                                   "#!/usr/bin/perl -T -I#{libexec}/lib/perl5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/monkeysphere v")
    # This just checks it finds the vendored Perl resource.
    assert_match "We need at least", pipe_output("#{bin}/openpgp2pem --help 2>&1")
  end
end
