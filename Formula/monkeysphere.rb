class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "http://web.monkeysphere.info/"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  revision 3
  head "git://git.monkeysphere.info/monkeysphere"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/monkeysphere/"
    regex(/href=.*?monkeysphere.?v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  bottle do
    cellar :any
    sha256 "1c72800477183baed866d396e2ed0fa238a20b3de8767fdf33a78beafcb369d8" => :big_sur
    sha256 "fdb224329c7d66b8770ff35746c94b8af3af96ad690e4cc24f384fd011ee0c3e" => :arm64_big_sur
    sha256 "1b6e0f281b0885de4151708205d92f3f8f237f8a4c5b966960bf01cc1196bb57" => :catalina
    sha256 "150dfcce34b75ba5e9e96ef6956ba0a6291088dd45ca1a1ebbf4b9d917291f34" => :mojave
  end

  depends_on "gnu-sed" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

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
