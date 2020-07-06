class Apcupsd < Formula
  desc "Daemon for controlling APC UPSes"
  homepage "http://www.apcupsd.org"
  url "https://downloads.sourceforge.net/project/apcupsd/apcupsd%20-%20Stable/3.14.14/apcupsd-3.14.14.tar.gz"
  sha256 "db7748559b6b4c3784f9856561ef6ac6199ef7bd019b3edcd7e0a647bf8f9867"
  license "GPL-2.0"

  bottle do
    rebuild 3
    sha256 "6bdbc101891e5c10b8aead1e1c86ce8ed1560f38b4de96a6c804c73953ad3ac0" => :catalina
    sha256 "f9e745573abb55d0194e958d48256ace18a8116fc2c7577617de915746e6c18b" => :mojave
    sha256 "8e604286ac22168ede829d3dff95ac782b458316c3389827c6d6c5168a2552e4" => :high_sierra
  end

  depends_on "gd"
  depends_on "libusb-compat"

  def install
    # Paths below are hard-coded upstream for creation of `.pkg` installer.

    sysconfdir = etc/name

    cd "src/apcagent" do
      # Install apcagent.app to `prefix`.
      inreplace "Makefile", "Applications", prefix
    end

    cd "platforms/darwin" do
      # Install launch daemon and kernel extension to subdirectories of `prefix`.
      inreplace "Makefile", "/Library/LaunchDaemons", "#{lib}/Library/LaunchDaemons"
      inreplace "Makefile", "/System/Library/Extensions", kext_prefix

      # Use appropriate paths for launch daemon and launch script.
      inreplace "apcupsd-start.in", "/etc/apcupsd", sysconfdir
      inreplace "org.apcupsd.apcupsd.plist.in", "/etc/apcupsd", sysconfdir

      # Custom uninstaller not needed as this is handled by Homebrew.
      inreplace "Makefile", /.*apcupsd-uninstall.*/, ""
    end

    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{sbin}",
                          "--sysconfdir=#{sysconfdir}",
                          "--enable-cgi", "--with-cgi-bin=#{sysconfdir}",
                          "--enable-usb", "--enable-modbus-usb"

    system "make", "install"
  end

  def caveats
    s = <<~EOS
      For #{name} to be able to communicate with UPSes connected via USB,
      the kernel extension must be installed by the root user:

        sudo cp -pR #{kext_prefix}/ApcupsdDummy.kext /System/Library/Extensions/
        sudo chown -R root:wheel /System/Library/Extensions/ApcupsdDummy.kext
        sudo touch /System/Library/Extensions/

    EOS

    if MacOS.version >= :el_capitan
      s += <<~EOS
        Note: On OS X El Capitan and above, the kernel extension currently
        does not work as expected.

        You will have to unplug and plug the USB cable back in after each
        reboot in order for #{name} to be able to connect to the UPS.

      EOS
    end

    s += <<~EOS
      To load #{name} at startup, activate the included Launch Daemon:

        sudo cp #{prefix}/lib/Library/LaunchDaemons/org.apcupsd.apcupsd.plist /Library/LaunchDaemons
        sudo chmod 644 /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
        sudo launchctl load -w /Library/LaunchDaemons/org.apcupsd.apcupsd.plist

      If this is an upgrade and you already have the Launch Daemon loaded, you
      have to unload the Launch Daemon before reinstalling it:

        sudo launchctl unload -w /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
        sudo rm /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
    EOS

    s
  end

  test do
    system "#{sbin}/apcupsd", "--version"
    assert_match /usage/, shell_output("#{sbin}/apctest --help", 1)
  end
end
