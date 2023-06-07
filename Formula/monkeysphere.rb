class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://tracker.debian.org/pkg/monkeysphere"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  license "GPL-3.0-or-later"
  revision 5

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/monkeysphere/"
    regex(/href=.*?monkeysphere.?v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "df5ff731a2d651eac23affb218b0dc5c5abab13913a2c004dadbc168a1abd5f5"
    sha256 cellar: :any,                 arm64_monterey: "397adb93474f514c346b827cd929079b24ca642441a4147d89be6dfe6da70ebf"
    sha256 cellar: :any,                 arm64_big_sur:  "ac722287373eebc6e390985d7a81a96d5e6c0bc7c291c79b22cd316bb4811ab8"
    sha256 cellar: :any,                 ventura:        "28b7e49490b7e74058d3d171e1eab5c086c9dfb23c6fbec2fb9a043c9695ebae"
    sha256 cellar: :any,                 monterey:       "aa86925d811df3182feabfd23e97134c1abdf5f25da2111d133a05b582e38627"
    sha256 cellar: :any,                 big_sur:        "6ede4524a1a0d9e217a2c7912f7fe8b0a8f9a4af414894f16d8783fe23180299"
    sha256 cellar: :any,                 catalina:       "05369ef69e30fc4dab35c09df091295be97e6b653dc882a9806f9b60991213a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "535b82abeb5f95380cecca0af8ed2e99768afab1f0e50a138388327cffd8078b"
  end

  depends_on "gnu-sed" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  resource "Crypt::OpenSSL::Guess" do
    on_linux do
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
