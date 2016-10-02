class Apcupsd < Formula
  desc "Daemon for controlling APC UPSes"
  homepage "http://www.apcupsd.org"
  url "https://downloads.sourceforge.net/project/apcupsd/apcupsd%20-%20Stable/3.14.14/apcupsd-3.14.14.tar.gz"
  sha256 "db7748559b6b4c3784f9856561ef6ac6199ef7bd019b3edcd7e0a647bf8f9867"

  bottle do
    cellar :any
    sha256 "bc7b9ee40a28adf5351ca70e4bf7f44d28cc849d6327d728e54309ebfb8b0289" => :sierra
    sha256 "faf979d85d50adebb20de24efbb113a52fe3760f5d4cc4bebda6eaec2268eb09" => :el_capitan
    sha256 "49cc19f7e0d435d5b70ef75d393de827207ad3ea821e9104d783c61692ea62ba" => :yosemite
    sha256 "488ed2fc48933a1c4ca08037016ae5af81050bdc27e7975296fd1c172cf10b31" => :mavericks
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
    s = <<-EOS.undent
      For #{name} to be able to communicate with UPSes connected via USB,
      the kernel extension must be installed by the root user:

        sudo cp -pR #{kext_prefix}/ApcupsdDummy.kext /System/Library/Extensions/
        sudo chown -R root:wheel /System/Library/Extensions/ApcupsdDummy.kext
        sudo touch /System/Library/Extensions/

    EOS

    if MacOS.version >= :el_capitan
      s += <<-EOS.undent
        Note: On macOS El Capitan and above, the kernel extension currently
        does not work as expected.

        You will have to unplug and plug the USB cable back in after each
        reboot in order for #{name} to be able to connect to the UPS.

      EOS
    end

    s += <<-EOS.undent
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
