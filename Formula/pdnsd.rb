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
    sha256 arm64_monterey: "3ea74a916606066431810d0b959ca508cb0fd6cb27c2902495db6e9cf6e1e30d"
    sha256 arm64_big_sur:  "2a39399ddd344c3d38b4052ca914dc99eebd452a9cf323518504c19671e7b2f6"
    sha256 monterey:       "76c55bb21dc763f58cb9bb6c8611811cec2d414825c5b0d66a295946c8871db4"
    sha256 big_sur:        "1ab46d6a13884a67fe91ecb554c53c8fc5fda4f2d453016cdd1242f8c362e9d5"
    sha256 catalina:       "125b690bbac734558cd9a4510c1336e2a92c3fd4748ba2ed216af9a5041c5d60"
    sha256 mojave:         "822ab7ede7c626ab8cb0c5e7340f3896cdef7cc112c8d9843e55d601f5847297"
    sha256 high_sierra:    "be218973e8fe1d807e7d9ec2762cab2a9968ce302fb46fb89974a686c1afcc43"
    sha256 sierra:         "81c4852b1093820909afc140f052f732cbd94e428d9aff261b90d74cb4935b09"
    sha256 el_capitan:     "1fa2f1f6ba9fc4fe710c1dc1d5bfb2b9663c557f5cdddf3a2fff8394f138a08f"
    sha256 x86_64_linux:   "4402ca761308936338a2c45fd5642eb8d19c80ec6700b1bcb79203f4396d76c4"
  end

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

  plist_options startup: true, manual: "sudo pdnsd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>Program</key>
        <string>#{opt_sbin}/pdnsd</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pdnsd.log</string>
        <key>StandardOutputPath</key>
        <string>#{var}/log/pdnsd.log</string>
        <key>Disabled</key>
        <false/>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "version #{version}",
      shell_output("#{sbin}/pdnsd --version", 1)
  end
end
