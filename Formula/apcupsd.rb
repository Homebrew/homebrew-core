class Apcupsd < Formula
  desc "Daemon for controlling APC UPSes"
  homepage "http://www.apcupsd.org"
  url "https://downloads.sourceforge.net/project/apcupsd/apcupsd%20-%20Stable/3.14.14/apcupsd-3.14.14.tar.gz"
  sha256 "db7748559b6b4c3784f9856561ef6ac6199ef7bd019b3edcd7e0a647bf8f9867"

  bottle do
    rebuild 1
    sha256 "d81a4973871bd62f3c638f4710c375fedd96ee92e57448d28247368705ae2576" => :catalina
    sha256 "2308c0cbde96d244e535e9fae11c501a49dc4aafa33fc1475b9285a3246e581e" => :mojave
    sha256 "beee3be60fc8aafbd2a8fdb215ec8f0d531cc6750d00fd176039a0e5d8ee0d1e" => :high_sierra
    sha256 "8cf3f4840ec564f859fa0b02eda9aec274180de519b512e28e19a31b6eab583c" => :sierra
    sha256 "d000cc771fde79714b634a49b31afd207d6a26b76924c586e0af9fa80f539db5" => :el_capitan
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
      inreplace "Makefile", "/Library/LaunchDaemons", "#{prefix}/Library/LaunchDaemons"
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

        sudo cp #{prefix}/Library/LaunchDaemons/org.apcupsd.apcupsd.plist /Library/LaunchDaemons
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
