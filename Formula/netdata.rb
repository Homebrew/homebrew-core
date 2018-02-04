class Netdata < Formula
  desc "Get control of your servers. Simple. Effective. Awesome!"
  homepage "https://my-netdata.io/"
  url "https://github.com/firehol/netdata/releases/download/v1.9.0/netdata-1.9.0.tar.bz2"
  sha256 "542b4799aed1ee03b0a0dbd00fae988a788622c431382e6429362fbbb4f0f017"

  depends_on "ossp-uuid"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :run

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--sbindir=#{bin}"
    system "make", "install"

    inreplace "system/netdata.conf", "web files owner = root", "web files owner = #{ENV["USER"]}"
    inreplace "system/netdata.conf", "web files group = netdata", "web files group = #{group}"

    conf_path = (etc/"netdata")
    conf_path.mkpath
    conf_path.install "system/netdata.conf" unless (conf_path/"netdata.conf").exist?
  end

  def group
    Etc.getgrgid(prefix.stat.gid).name
  end

  plist_options :manual => "netdata"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <!-- key>OnDemand</key>
        <true/ -->
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{bin}/netdata</string>
            <string>-D</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/netdata", "-W", "unittest"
  end
end
