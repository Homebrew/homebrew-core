class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/v1.12.tar.gz"
  sha256 "f43a7ea7f71db896338224b32f5e534951a976f13b7ef7a4fb5f5aed9f57883f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d2a2ae37dc5914fc8f9a81973e056d5d310a12e87ab089a97f47d0fa8a6168b" => :big_sur
    sha256 "7a3ff3ad7d79b13d3df7b8048134f8e7321d2daf4fa61c80e57041dff7a3d5ec" => :arm64_big_sur
    sha256 "eb308ce225c6f335a5a27518b63f8ce70caa263e94afbb7d9c2bb9000c12d974" => :catalina
    sha256 "da06f9b4142a163f26de89e5d67c729fd4edd9fbd2dcf3ada91507f92f45ec93" => :mojave
    sha256 "d57a1db5de295181c1f5596951160cc65b7f27645806fb35834f6409cbc57a6e" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options manual: "beanstalkd"

  def plist
    <<~EOS
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
            <string>#{opt_bin}/beanstalkd</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/beanstalkd.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/beanstalkd.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/beanstalkd", "-v"
  end
end
