class Netdata < Formula
  desc "Distributed real-time performance and health monitoring"
  homepage "https://my-netdata.io/"
  url "https://github.com/netdata/netdata/releases/download/v1.17.0/netdata-v1.17.0.tar.gz"
  sha256 "c6278ef7a0885422053b6acc596f65d117c32e45a342cc6f2414d3e29add3d25"

  bottle do
    sha256 "e9040b10b7c12c399bf3251dff36eb86dd50fdf7a9e92b7211fb6621b2754c56" => :mojave
    sha256 "5071140754f4b4a6814bf37cb656ad48bea2f4c5a18fc808e490a0d2acf506f4" => :high_sierra
    sha256 "d4c48c0cca02fc6835683f33b8f1bf447ef60bf6abbd2b384f34df19ec2fd7b1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1" if MacOS.version <= :sierra

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--libexecdir=#{libexec}",
                          "--with-math",
                          "--with-zlib",
                          "--with-user=netdata",
                          "UUID_CFLAGS=-I/usr/include",
                          "UUID_LIBS=-lc"
    system "make", "clean"
    system "make", "install"

    (etc/"netdata").install "system/netdata.conf"
  end

  def post_install
    config = etc/"netdata/netdata.conf"
    inreplace config do |s|
      s.gsub!(/web files owner = .*/, "web files owner = #{ENV["USER"]}")
      s.gsub!(/web files group = .*/, "web files group = #{Etc.getgrgid(prefix.stat.gid).name}")
    end
    (var/"netdata").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/netdata -D"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
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
    system "#{sbin}/netdata", "-W", "set", "registry", "netdata unique id file",
                              "#{testpath}/netdata.unittest.unique.id",
                              "-W", "set", "registry", "netdata management api key file",
                              "#{testpath}/netdata.api.key",
                              "-W", "unittest"
  end
end
