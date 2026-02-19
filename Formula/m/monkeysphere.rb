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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "270aaca29d4132b3fe6334cfdb4fb76c3fc1719af706ebbc2efdab1ecfaf2bb2"
    sha256 cellar: :any,                 arm64_sequoia: "a2a32750ec3795bc95626c88255eff29170a8aa91d4f39cf6bb24dce87f8dd99"
    sha256 cellar: :any,                 arm64_sonoma:  "15eb16e6f47470cec82e402aae7b64ff696fe6bd7c7ddfb8d3d3eb2e884a5c22"
    sha256 cellar: :any,                 sonoma:        "2e7ba58c484a094f7ff4bfd954997e66bd97adf3f41014a2d62541c92df46f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7e31987425d7b97ebc7ed8413f9ae776b4a031851094f2074e062d1d68d9d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1914ebe00f06674a892da92c25d236f87e05dfe185728a961fa19373ba9d0c42"
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
