class Pdnsd < Formula
  desc "Proxy DNS server with permanent caching"
  # The upstream urls are currently down, so temporarily use an archived copy.
  homepage "https://web.archive.org/web/20201203080556/members.home.nl/p.a.rombouts/pdnsd/"
  url "https://web.archive.org/web/20200323100335/members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-1.2.9a-par.tar.gz"
  mirror "https://fossies.org/linux/misc/dns/pdnsd-1.2.9a-par.tar.gz"
  version "1.2.9a-par"
  sha256 "bb5835d0caa8c4b31679d6fd6a1a090b71bdf70950db3b1d0cea9cf9cb7e2a7b"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "9ddb9a075c4ca211351979db780d89982bdaaad387b43055c96082cd50a6ed20"
    sha256 arm64_sonoma:   "1ff9eec76617f6a8f60821ff67791c419a44954098c6b5b4f9a41b73f5cca583"
    sha256 arm64_ventura:  "3319b3306f0a2561742e6f9cf3fe9fc826586ac3d9f2cb039df3f173bde01348"
    sha256 arm64_monterey: "3ea74a916606066431810d0b959ca508cb0fd6cb27c2902495db6e9cf6e1e30d"
    sha256 arm64_big_sur:  "2a39399ddd344c3d38b4052ca914dc99eebd452a9cf323518504c19671e7b2f6"
    sha256 sonoma:         "52cfde24914000c9a1f809d4c31307ebae9b871c54737c08c52774b72a4ad7a4"
    sha256 ventura:        "2963deb135757a0f82f140f9dadbfe35e8431d83ae1eecf67dd04dea88461012"
    sha256 monterey:       "76c55bb21dc763f58cb9bb6c8611811cec2d414825c5b0d66a295946c8871db4"
    sha256 big_sur:        "1ab46d6a13884a67fe91ecb554c53c8fc5fda4f2d453016cdd1242f8c362e9d5"
    sha256 catalina:       "125b690bbac734558cd9a4510c1336e2a92c3fd4748ba2ed216af9a5041c5d60"
    sha256 x86_64_linux:   "4402ca761308936338a2c45fd5642eb8d19c80ec6700b1bcb79203f4396d76c4"
  end

  # The upstream urls have been dead since at least 2021.
  # Last release on 2012-03-17
  deprecate! date: "2024-03-31", because: :unmaintained
  disable! date: "2025-03-31", because: :unmaintained

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-cachedir=#{var}/cache/pdnsd"
    system "make", "install"
  end

  def caveats
    <<~EOS
      This install of "pdnsd" expects config files to be in #{etc}
      All state files (status and cache) are stored in #{var}/cache/pdnsd.

      pdnsd needs to run as root since it listens on privileged ports.

      Sample config file can be found at #{etc}/pdnsd.conf.sample.

      Note that you must create the config file before starting the service,
      and change ownership to "root" or pdnsd will refuse to run:
        sudo chown root #{etc}/pdnsd.conf

      For other related utilities, e.g. pdnsd-ctl, to run, change the ownership
      to the user (default: nobody) running the service:
        sudo chown -R nobody #{var}/log/pdnsd.log #{var}/cache/pdnsd
    EOS
  end

  service do
    run opt_sbin/"pdnsd"
    keep_alive true
    error_log_path var/"log/pdnsd.log"
    log_path var/"log/pdnsd.log"
  end

  test do
    assert_match "version #{version}",
      shell_output("#{sbin}/pdnsd --version", 1)
  end
end
