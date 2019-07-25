class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://web.monkeysphere.info/"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  head "git://git.monkeysphere.info/monkeysphere"

  bottle do
    cellar :any
    sha256 "9cfe15130a5950d276146c72a4945d09b29c4ebc9ef15b6d92f0d8527e0afbf9" => :mojave
    sha256 "4854342d29ac57b1e9c0d040ae7a601065b29332c3e35fde847cee7783e3e37e" => :high_sierra
    sha256 "d0532dad405696179a0e94359cf5908613c1def95e82b8c9cfe88eba7e1843cf" => :sierra
    sha256 "6feb6d2bbd4a0d49dde32d9d26e17bbef7e48ccadb9ffcb82f1b7899386d1b38" => :el_capitan
    sha256 "7d32f5718f0302eb6b009b030dfb0279ebd471e808cafa3ca264a8fd4817b5ca" => :yosemite
  end

  depends_on "gnu-sed" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl"

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
