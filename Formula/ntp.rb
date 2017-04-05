class Ntp < Formula
  desc "The Network Time Protocol (NTP) Distribution"
  homepage "https://www.eecis.udel.edu/~mills/ntp/html/"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p10.tar.gz"
  version "4.2.8p10"
  sha256 "ddd2366e64219b9efa0f7438e06800d0db394ac5c88e13c17b70d0dcdf99b99f"

  devel do
    url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-dev/ntp-dev-4.3.93.tar.gz"
    sha256 "a07e73d7a3ff139bba33ee4b1110d5f3f4567465505d6317c9b50eefb9720c42"
  end

  head do
    ## The git repo is broken/ancient, per
    ## https://github.com/ntp-project/ntp/issues/17 but the others
    ## aren't much better.
    ##
    ## bk://bk.ntp.org/ntp-dev
    ## (4.3.93) 2016/06/02 Released by Harlan Stenn <stenn@ntp.org>

    # Unsupported syntax?: depends_on cask: "bitkeeper"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "lynx" => :build
  end

  option "with-net-snmp", "Build net-snmp support"

  depends_on "openssl"
  depends_on "net-snmp" => :optional

  def install
    # Ensure homebrew perl is in #! lines of installed scripts.
    localperl="/usr/local/bin/perl"
    ENV["PATH_PERL"] = localperl if File.exist? localperl

    system "./bootstrap" if build.head?

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-openssl-libdir=#{Formula["openssl"].lib}",
      "--with-openssl-incdir=#{Formula["openssl"].include}",
    ]
    if build.with?("net-snmp")
      args <<  "-with-net-snmp-config"
    else
      args << "-with-net-snmp-config=no"
    end

    system "./configure", *args
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
    assert_match "step time server ", shell_output("#{sbin}/ntpdate -bq pool.ntp.org")
  end
end
