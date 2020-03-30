class Jobber < Formula
  desc "Alternative to cron, with better status-reporting and error-handling"
  homepage "https://dshearer.github.io/jobber/"
  url "https://github.com/dshearer/jobber/archive/v1.4.3.tar.gz"
  sha256 "14efd9e088e4b3e1e4018fb8cd3161cc43da7941261b31c3e90d630545b305db"
  head "https://github.com/dshearer/jobber.git"

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--libexecdir=#{libexec}", "--sysconfdir=#{etc}",
      "--localstatedir=#{var}"
    system "make", "install"
  end

  plist_options :startup => true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{libexec}/jobbermaster</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardOutPath</key>
          <string>#{var}/log/jobber.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/jobber.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/".jobber").write <<~EOS
      version: 1.4
      jobs:
        Test:
          cmd: 'echo "Hi!" > "#{testpath}/output"'
          time: '*'
    EOS

    fork do
      exec libexec/"jobberrunner", "#{testpath}/.jobber"
    end
    sleep 3

    assert_match "Hi!", (testpath/"output").read
  end
end
