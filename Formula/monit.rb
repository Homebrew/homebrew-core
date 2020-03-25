class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-5.26.0.tar.gz"
  sha256 "87fc4568a3af9a2be89040efb169e3a2e47b262f99e78d5ddde99dd89f02f3c2"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "2469520cd629319f5ca58f4791d1f830be411643199658e5c249b401d143f8b2" => :catalina
    sha256 "6bad371cf6ef0737965a8bc0af08838e4272a1fd12462123878185e0e477c50b" => :mojave
    sha256 "049b5bc40d764cd3b4e27d651e4c28c58d3438d07714bb566ba1af6cfcbd8011" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  plist_options :manual => "monit -I -c #{HOMEBREW_PREFIX}/etc/monitrc"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>              <string>#{plist_name}</string>
          <key>ProcessType</key>        <string>Adaptive</string>
          <key>Disabled</key>           <false/>
          <key>RunAtLoad</key>          <true/>
          <key>LaunchOnlyOnce</key>     <false/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/monit</string>
            <string>-I</string>
            <string>-c</string>
            <string>#{etc}/monitrc</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
