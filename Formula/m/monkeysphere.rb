class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://tracker.debian.org/pkg/monkeysphere"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  license "GPL-3.0-or-later"
  revision 9

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/monkeysphere/"
    regex(/href=.*?monkeysphere.?v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c9e8dcdb90ed4f9787eeac0331f5fa3e46bed605cff5b34530d24653c7e17420"
    sha256 cellar: :any,                 arm64_sequoia: "40d8c3289f12c710d030f446886eb4e45c396e4b1517dbc722a6e639cd113193"
    sha256 cellar: :any,                 arm64_sonoma:  "898254e686c3406c0af79584f182a97fd0796a66f755055c3c59745850ee6bde"
    sha256 cellar: :any,                 arm64_ventura: "e04ebbbfc60f349cebc2a8574367934080b0c52c61e6ed1d988b5965b4a2650e"
    sha256 cellar: :any,                 sonoma:        "855d71f1d6e31d991fa30df070c136fcaa99457573f16ac6e05defae3e3ac7d3"
    sha256 cellar: :any,                 ventura:       "ac5c54b17c62e126b1f10c18918fd2a66e8bff38a0a51379e7ddac0890fa9997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7683b31a0dafac66f8ccb8947c440af2225b6340a9934b0fb7e1d897001ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21398c0664f91eddb4e26a9b1f00cdc17e3462647651c04ada0eaa76a93d0b19"
  end

  depends_on "gnu-sed" => :build
  depends_on "pkgconf" => :build
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
