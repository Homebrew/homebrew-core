class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  # Arguments could be made for:
  # http://ntp.org/documentation.html (has more unofficial stuff)
  # http://ntp.org/  (more the protocol than the distribution)
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p10.tar.gz"
  version "4.2.8p10"
  sha256 "ddd2366e64219b9efa0f7438e06800d0db394ac5c88e13c17b70d0dcdf99b99f"

  devel do
    # http://support.ntp.org/bin/view/Main/SoftwareDevelopment
    url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-dev/ntp-dev-4.3.93.tar.gz"
    sha256 "a07e73d7a3ff139bba33ee4b1110d5f3f4567465505d6317c9b50eefb9720c42"
  end

  head do
    ## The git repo is broken/ancient, per https://github.com/ntp-project/ntp/issues/17
    ## but the others aren't much better.
    #
    ## url "https://github.com/ntp-project/ntp.git"
    ## Default stable branch: 1a399a03e674da08cfce2cdb847bfb65d65df237, Jan 24 2016
    ## Non-default "master" branch: 9c75327c3796ff59ac648478cd4da8b205bceb77 Sun Jan 24 12:06:39 2016 +0000
    #
    ## bk://bk.ntp.org/ntp-stable
    ## (4.2.8p10-win-beta1) 2017/03/21 Released by Harlan Stenn <stenn@ntp.org>
    #
    ## bk://bk.ntp.org/ntp-dev
    ## (4.3.93) 2016/06/02 Released by Harlan Stenn <stenn@ntp.org>
    #
    ## rsync archive.ntp.org::ntp-dev-src
    ## (4.3.92) 2016/04/27 Released by Harlan Stenn <stenn@ntp.org>

    # Unsupported syntax?: depends_on cask: "bitkeeper"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  depends_on "openssl"

  def install
    # Ensure homebrew perl is in #! lines of installed scripts.
    ENV["PATH_PERL"] = "/usr/local/bin/perl"

    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl-libdir=#{Formula["openssl"].lib}",
                          "--with-openssl-incdir=#{Formula["openssl"].include}"

    system "make", "install"
  end

  def caveats
    s = <<-EOS.undent
    By default, OS X ships a broken version of ntpd that by design
    does not control the system clock, but maintains the network
    protocol and is intended to write a drift file (which it fails to
    do under OS X 10.10). The drift file is read by pacemaker(8),
    which is supposed to call adjtime() in a battery-efficient fashion
    for laptops.

    Installing this formula implies disabling the system ntpd as well as pacemaker:

    sudo launchctl disable system/com.apple.pacemaker
    sudo launchctl disable system/org.ntp.ntpd
    EOS
    s
  end

  plist_options :startup => true

  # OS X uses /usr/libexec/ntp-wrapper to wait for appropriate network conditions and then
  # invoke ntpd with various args. It's not clear that we need to resort to that. It also
  # runs sntp first, which is definitely unnecessary given ntpd -g.
  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ntpd</string>
        <string>-c</string>
        <string>/private/etc/ntp-restrict.conf</string>
        <string>-n</string>
        <string>-g</string>
        <string>-p</string>
        <string>/var/run/ntpd.pid</string>
        <string>-f</string>
        <string>/var/db/ntp.drift</string>
        <string>-l</string>
        <string>/var/log/ntp.log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    # It's hard to do anything without network or clock-invasive stuff.
    # Make sure we can print a usage message.
    assert_match "usage: ", shell_output("#{sbin}/ntpdate -\? 2>&1", 2)
  end
end
