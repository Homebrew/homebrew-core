class Netdata < Formula
  desc "Distributed real-time performance and health monitoring"
  homepage "https://my-netdata.io/"
  url "https://github.com/firehol/netdata/releases/download/v1.9.0/netdata-1.9.0.tar.bz2"
  sha256 "542b4799aed1ee03b0a0dbd00fae988a788622c431382e6429362fbbb4f0f017"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"

    conf_path = etc/"netdata"
    conf_path.mkpath
    conf_path.install "system/netdata.conf"
  end

  def post_install
    config = etc/"netdata/netdata.conf"
    return unless File.exist?(config)
    return if File.read(config).include?(ENV["USER"])
    inreplace config do |s|
      s.gsub!(/web files owner = .*/, "web files owner = #{ENV["USER"]}")
      s.gsub!(/web files group = .*/, "web files group = #{Etc.getgrgid(prefix.stat.gid).name}")
    end
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/netdata -D"

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
            <string>#{opt_sbin}/netdata</string>
            <string>-D</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/netdata",
      "-W", "set", "registry",
      "netdata unique id file",
      "#{testpath}/netdata.unittest.unique.id",
      "-W", "unittest"
  end
end
