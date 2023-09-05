class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "https://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.43/ircd-hybrid-8.2.43.tgz"
  sha256 "bd0373c780e308c1a6f6989015ff28e1c22999ef764b7b68636b628573c251ef"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ircd-hybrid[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "6a81e2c060cd566f402869f96af0ed8c64a0ed34bab832d647e7376b55b208ff"
    sha256 arm64_monterey: "8278654b1edca6191c1d549e796919b6836e524feb4a59b44860f817965b81da"
    sha256 arm64_big_sur:  "b3927d1e5ddbfb44800b02eee5fd9fe88fc597589f3810fd1fd41deb20713f4a"
    sha256 ventura:        "5a528cd1893e00df7ccbfe9b9fb324dc3574da86c6a358113ded14fe7e2407bb"
    sha256 monterey:       "c7ffbfb6de2e476e248bd63c2b963abee68e684ce4aac3042c9406e12ecad09e"
    sha256 big_sur:        "2eea0b23275797fe30f9095cbaebb167d707a08250bc66f5a0c729851bba7776"
    sha256 catalina:       "2a1ce03715e20c3fb69c1716362471a7d1ee2ed4230c8db80347c7ef42986b7e"
    sha256 x86_64_linux:   "e2bd735a173dbb77da8bb51a30b82844d4225f4ee2e3056c2afbc5c624c623be"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  conflicts_with "expect", because: "both install an `mkpasswd` binary"
  conflicts_with "ircd-irc2", because: "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats
    <<~EOS
      You'll more than likely need to edit the default settings in the config file:
        #{etc}/ircd.conf
    EOS
  end

  service do
    run opt_bin/"ircd"
    keep_alive false
    working_dir HOMEBREW_PREFIX
    error_log_path var/"ircd.log"
  end

  test do
    system "#{bin}/ircd", "-version"
  end
end
