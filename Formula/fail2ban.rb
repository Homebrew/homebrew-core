class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/0.9.6.tar.gz"
  sha256 "1712e4eda469513fb2f44951957a4159e0fa62cb9da16ed48e7f4f4037f0b976"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bbb4f2f3f6b8990a9630d82630174cd62808850f9783bf15ad556759b0b02592" => :sierra
    sha256 "1c546abfdb096457c188bd32f97f95368c9e11e0d9eb0b44172e130083b26205" => :el_capitan
    sha256 "024aff8d53788e55039de105bef04036b97cdde3b62a67a750a5b748f2b5389a" => :yosemite
    sha256 "f39d0f4aa122b1e40ce05ad9010901beefacd560c5d84960eed4448daa3915f2" => :mavericks
  end

  depends_on :python

  def install
    rm "setup.cfg"
    inreplace "setup.py" do |s|
      s.gsub! %r{/etc}, etc
      s.gsub! %r{/var}, var
    end

    inreplace "bin/fail2ban-client", "/etc", etc

    inreplace "bin/fail2ban-server", "/var", var
    inreplace "config/fail2ban.conf", "/var/run", (var/"run")

    inreplace "setup.py", "/usr/share/doc/fail2ban", (libexec/"doc")

    system "python", *Language::Python.setup_install_args(prefix)
  end

  def caveats
    <<-EOS.undent
      Before using Fail2Ban for the first time you should edit jail
      configuration and enable the jails that you want to use, for instance
      ssh-ipfw. Also make sure that they point to the correct configuration
      path. I.e. on Mountain Lion the sshd logfile should point to
      /var/log/system.log.

        * #{etc}/fail2ban/jail.conf

      The Fail2Ban wiki has two pages with instructions for macOS Server that
      describes how to set up the Jails for the standard macOS Server
      services for the respective releases.

        10.4: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.4)
        10.5: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.5)
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/fail2ban-client</string>
          <string>-x</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"fail2ban-client", "-h"
    system bin/"fail2ban-server", "-h"
  end
end
