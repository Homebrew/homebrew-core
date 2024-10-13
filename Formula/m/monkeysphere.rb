class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "https://tracker.debian.org/pkg/monkeysphere"
  url "https://deb.debian.org/debian/pool/main/m/monkeysphere/monkeysphere_0.44.orig.tar.gz"
  sha256 "6ac6979fa1a4a0332cbea39e408b9f981452d092ff2b14ed3549be94918707aa"
  license "GPL-3.0-or-later"
  revision 8

  livecheck do
    url "https://deb.debian.org/debian/pool/main/m/monkeysphere/"
    regex(/href=.*?monkeysphere.?v?(\d+(?:\.\d+)+)(?:\.orig)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bf39fe1f43e0f79f5b95112f73de0103b63b8887d996b9dab6c74a834083cb79"
    sha256 cellar: :any,                 arm64_sonoma:   "adbac1f101bf44b5ca24fd551cf7858577857f16766b180d479890a81d83642f"
    sha256 cellar: :any,                 arm64_ventura:  "951360b4729225a4122be52b6caad531aecb6b93f69d36e69ae58755420ac3b2"
    sha256 cellar: :any,                 arm64_monterey: "e0ba9c5746bef445dbe284fb70b3dabfc52d905d1c837dc6c2aaaa9c5977a89b"
    sha256 cellar: :any,                 sonoma:         "b5f1abc5720e355bced5bc5a476b1d5cf4289a4ba8a52695f4e31cf90e27577c"
    sha256 cellar: :any,                 ventura:        "820014adb3f1e79e8d65cabaa355f90fc912768dfb29d0fc6b2f117f33574528"
    sha256 cellar: :any,                 monterey:       "f2d9d5fc6587cb1402f89c0117664725b1e0afb044488918a89e1bf2b15da793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab882a62dd621d6c7216044f5263366f63e6c18dd5a15747b53236be9c092c02"
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
