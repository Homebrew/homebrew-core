class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "http://web.monkeysphere.info/"
  url "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_0.39.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.39.orig.tar.gz"
  sha256 "73331e2df361b22e1dc6445a7d2b0b2c5a124daa4d850c2ecce721579592c29f"
  head "git://git.monkeysphere.info/monkeysphere"

  bottle do
    cellar :any
    sha256 "76170e317e70f7027278463203c695e7e61b1a2a7f841296f94cd82392c2feca" => :sierra
    sha256 "8d057775a9b16a205550233f48f24134edee51b2684042778fa0848b4195e9a1" => :el_capitan
    sha256 "5d7bb88c89986665c4661d75ae3ac4c014ff3da2870fd51a4f788fb33d1b17a3" => :yosemite
    sha256 "d408b3a9b1cdc46fca399e29d0dd7c1e0c2a81e3c9e02b07460acf8c36b3abe9" => :mavericks
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
