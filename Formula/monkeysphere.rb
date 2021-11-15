class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://web.monkeysphere.info/"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  license "GPL-3.0-or-later"
  revision 4
  head "git://git.monkeysphere.info/monkeysphere"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/monkeysphere/"
    regex(/href=.*?monkeysphere.?v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3bd12fd46a4c71a6192363e3fcf693be27644a294e4f79d5161fcc6682408595"
    sha256 cellar: :any,                 arm64_big_sur:  "9a63b22184c6039b5e97ce75d7f9aa6168817a6762871636041be765f1f78302"
    sha256 cellar: :any,                 monterey:       "f7b88043cb09a0c5d318b021448d591f8fcdb4a87d142327eda4a40ff2e36ce2"
    sha256 cellar: :any,                 big_sur:        "f6d43ab1186cc4e12533ec7c7cad460bac24c260a933dde10bc19a4f2f4c625c"
    sha256 cellar: :any,                 catalina:       "072b5372d6b15f27c2330751004f9da2922547eba1944f881412a8b7ded8b8b5"
    sha256 cellar: :any,                 mojave:         "2c2dfe55c8fa2b30e16808c5100379eb1380b3bb8295cb8ba24f515eb02063f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5f694d15b5b01613728b59bc539d1a8896b7e326287f22fe23d40ef2b3b6bab"
  end

  depends_on "gnu-sed" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  on_linux do
    resource "Crypt::OpenSSL::Guess" do
      url "https://cpan.metacpan.org/authors/id/A/AK/AKIYM/Crypt-OpenSSL-Guess-0.13.tar.gz"
      sha256 "87c1dd7f0f80fcd3d1396bce9fd9962e7791e748dc0584802f8d10cc9585e743"
    end
  end

  resource "Crypt::OpenSSL::Bignum" do
    url "https://cpan.metacpan.org/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.09.tar.gz"
    sha256 "234e72fb8396d45527e6fd45e43759c5c3f3a208cf8f29e6a22161a996fd42dc"
  end

  resource "Crypt::OpenSSL::RSA" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Crypt-OpenSSL-RSA-0.31.tar.gz"
    sha256 "4173403ad4cf76732192099f833fbfbf3cd8104e0246b3844187ae384d2c5436"
  end

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    res = if OS.mac? && MacOS.version <= :catalina
      [resource("Crypt::OpenSSL::Bignum")]
    else
      resources
    end

    res.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
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
