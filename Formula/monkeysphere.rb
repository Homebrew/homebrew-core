class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "http://web.monkeysphere.info/"
  url "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_0.40.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.40.orig.tar.gz"
  sha256 "141d49a4434c2271347c169586444cda1335eeeece3b5fe5fd71a0095483a5c1"
  head "git://git.monkeysphere.info/monkeysphere"

  bottle do
    cellar :any
    sha256 "c75b8cee8c3b46090dba8f028e4e3164964d4e87a21bfe1ea1e01f6356215185" => :sierra
    sha256 "5fec7eadab92a7c33275603f7f7a31e754630a45da89cdc084ed002c5596f3e5" => :el_capitan
    sha256 "4fc0342da66daed73ef4343ec7642e65dafd0a508555df0481bc0d6c89b08396" => :yosemite
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
