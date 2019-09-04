class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://web.monkeysphere.info/"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  revision 1
  head "git://git.monkeysphere.info/monkeysphere"

  bottle do
    cellar :any
    sha256 "61b9425d289423b64a68363b1ac2b152fc622a793cb40e150241f08b9a498428" => :mojave
    sha256 "0c9f5f886595332443a7e4b7c8b9774a27ef7933b090953d8cf87cbf03fb32d4" => :high_sierra
    sha256 "2664e994707e98c5c01e51706879b31a2837cccf8fe33a3e1f45b8ce3be2610f" => :sierra
  end

  depends_on "gnu-sed" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@1.1"

  resource "Crypt::OpenSSL::Bignum" do
    url "https://cpan.metacpan.org/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.09.tar.gz"
    sha256 "234e72fb8396d45527e6fd45e43759c5c3f3a208cf8f29e6a22161a996fd42dc"
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
