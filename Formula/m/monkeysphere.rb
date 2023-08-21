class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://tracker.debian.org/pkg/monkeysphere"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  license "GPL-3.0-or-later"
  revision 6

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/monkeysphere/"
    regex(/href=.*?monkeysphere.?v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "728f6625c94c2f1117680043040da86964132758702159e53b28f655032fce4a"
    sha256 cellar: :any,                 arm64_monterey: "d755663a07608287f1d14512c9a192907a60674456df96368ded7456b71a84c8"
    sha256 cellar: :any,                 arm64_big_sur:  "b939793eb175a2d4ba85afe54360ae1c1d2e18e65bfbe48da3d3a1c1f7e4f6e9"
    sha256 cellar: :any,                 ventura:        "0028241b0874b2909d437fca8628a12ecaef0b01582e444468d8c148c0c95434"
    sha256 cellar: :any,                 monterey:       "34cd3db42f71f5693572fd7033880ce59dc368902fd138fa991c0b9ad2f13282"
    sha256 cellar: :any,                 big_sur:        "72462262364ea78369735b4fbbbb29c41ac08d103305fcf664aa53af1df7d199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36140b1926ed1243e59776aad0dc4b0b065f0e8dc09749c31e7fac8719ae9227"
  end

  depends_on "gnu-sed" => :build
  depends_on "pkg-config" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@3"

  uses_from_macos "perl"

  resource "Crypt::OpenSSL::Guess" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/A/AK/AKIYM/Crypt-OpenSSL-Guess-0.15.tar.gz"
      sha256 "1c5033381819fdb4c9087dd291b90ec70e7810d31d57eade9b388eccfd70386d"
    end
  end

  resource "Crypt::OpenSSL::Bignum" do
    url "https://cpan.metacpan.org/authors/id/K/KM/KMX/Crypt-OpenSSL-Bignum-0.09.tar.gz"
    sha256 "234e72fb8396d45527e6fd45e43759c5c3f3a208cf8f29e6a22161a996fd42dc"
  end

  resource "Crypt::OpenSSL::RSA" do
    url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/Crypt-OpenSSL-RSA-0.33.tar.gz"
    sha256 "bdbe630f6d6f540325746ad99977272ac8664ff81bd19f0adaba6d6f45efd864"
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
