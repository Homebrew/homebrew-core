class Apcupsd < Formula
  desc "Daemon for controlling APC UPSes"
  homepage "http://www.apcupsd.org"
  url "https://downloads.sourceforge.net/project/apcupsd/apcupsd%20-%20Stable/3.14.14/apcupsd-3.14.14.tar.gz"
  sha256 "db7748559b6b4c3784f9856561ef6ac6199ef7bd019b3edcd7e0a647bf8f9867"
  license "GPL-2.0-only" # a few files have "or later", but most do not

  livecheck do
    url :stable
    regex(%r{url=.*?/apcupsd%20-%20Stable/[^/]+/apcupsd[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 4
    sha256 arm64_monterey: "a6cf4c78394837233cb366da2697b0c80a69d5191b09b5aba0125d40fcdb48a5"
    sha256 arm64_big_sur:  "891644e5123fc8fd644cf88809642334f07093f7dae656c3f65d276e90a2b6bf"
    sha256 monterey:       "e1b0cba1a14c977d8a7faad52c9d72080b745f7b3a49557a5cebe8171bcbc9a1"
    sha256 big_sur:        "1c425f1d6db43a760e4d068ae8ef193c3ca32a3157564989ba1a6aa2ce44a2c7"
    sha256 catalina:       "7636fe8d43fde7368817c64dc8f689526f48d2a958532e3fdd3f05db3deb4c5e"
    sha256 mojave:         "7c87a398311314a0f789cabb5956932962800297e2ba4890f07ac60c13cc3f68"
    sha256 x86_64_linux:   "d393e850548713a383f89d2375fdbd895eae93c063c97b7e16cd767c881d983e"
  end

  depends_on "gd"
  depends_on "libusb-compat"

  def install
    sysconfdir = etc/name
    args = %W[
      --prefix=#{prefix}
      --sbindir=#{sbin}
      --sysconfdir=#{sysconfdir}
      --enable-cgi
      --with-cgi-bin=#{sysconfdir}
      --enable-usb
      --enable-modbus-usb
    ]

    if OS.mac?
      # Detecting the lack of gethostname_r() goes wrong on Xcode 12:
      args << "ac_cv_func_which_gethostbyname_r=no"

      # Paths below are hard-coded upstream for creation of `.pkg` installer.

      # Install apcagent.app to `prefix`.
      inreplace "src/apcagent/Makefile", "Applications", prefix

      cd "platforms/darwin" do
        inreplace "Makefile" do |s|
          # Install launch daemon and kernel extension to subdirectories of `prefix`.
          s.gsub! "/Library/LaunchDaemons", lib/"Library/LaunchDaemons"
          s.gsub! "/System/Library/Extensions", kext_prefix
          # Custom uninstaller not needed as this is handled by Homebrew.
          s.gsub!(/.*apcupsd-uninstall.*/, "")
        end

        # Use appropriate paths for launch daemon and launch script.
        inreplace %w[apcupsd-start.in org.apcupsd.apcupsd.plist.in], "/etc/apcupsd", sysconfdir
      end
    else
      # Avoid Linux distro-specific paths
      args << "--with-distname=unknown"
      args << "--with-halpolicydir=#{share}/hal/fdi/policy/20thirdparty"
    end

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        For #{name} to be able to communicate with UPSes connected via USB,
        the kernel extension must be installed by the root user:

          sudo cp -pR #{kext_prefix}/ApcupsdDummy.kext /System/Library/Extensions/
          sudo chown -R root:wheel /System/Library/Extensions/ApcupsdDummy.kext
          sudo touch /System/Library/Extensions/

          Note: On OS X El Capitan and above, the kernel extension currently
          does not work as expected.

          You will have to unplug and plug the USB cable back in after each
          reboot in order for #{name} to be able to connect to the UPS.

        To load #{name} at startup, activate the included Launch Daemon:

          sudo cp #{prefix}/lib/Library/LaunchDaemons/org.apcupsd.apcupsd.plist /Library/LaunchDaemons
          sudo chmod 644 /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
          sudo launchctl load -w /Library/LaunchDaemons/org.apcupsd.apcupsd.plist

        If this is an upgrade and you already have the Launch Daemon loaded, you
        have to unload the Launch Daemon before reinstalling it:

          sudo launchctl unload -w /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
          sudo rm /Library/LaunchDaemons/org.apcupsd.apcupsd.plist
      EOS
    end
  end

  test do
    system sbin/"apcupsd", "--version"
    assert_match "usage", shell_output("#{sbin}/apctest --help", 1)
  end
end
