class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://tracker.debian.org/pkg/monkeysphere"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  license "GPL-3.0-or-later"
  revision 10

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/monkeysphere/"
    regex(/href=.*?monkeysphere.?v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "65bb0bb595490c01778c36ff4705be95e6c967c0f6a533a7583fa6d2a293a27b"
    sha256 cellar: :any, arm64_tahoe:       "074d6d5b27ab99e06b6451294aa7faaceb2472ebd2ecfe004a871489c7121b83"
    sha256 cellar: :any, arm64_sequoia:     "600bb8e7616af38f8f49c2e6283d447ccba6294ca7bd128e07d624c723d89881"
    sha256 cellar: :any, arm64_linux:       "53b4e37dbc0cec12dacec7a783001815d75bd9209b5f7e62ddf711cb2c207f2b"
    sha256 cellar: :any, x86_64_linux:      "c0364318aef58e10a7e2b87afa91503954ac9dab52b880df153c17a53094a013"
  end

  # Original site is gone. We currently use Debian URLs but Debian removed package
  # in Debian 12 (Bookworm) and prior Debian 11 (Bullseye) LTS ends on 2026-08-31.
  deprecate! date: "2026-05-25", because: :unmaintained
  disable! date: "2027-05-25", because: :unmaintained

  depends_on "gnu-sed" => :build
  depends_on "pkgconf" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@4"

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
    ENV["OPENSSL_PREFIX"] = formula_opt_prefix("openssl@4")
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
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
