class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "https://nsq.io/"
  url "https://github.com/nsqio/nsq/archive/v1.2.0.tar.gz"
  sha256 "98e24d748550f01dd8775e5e40f3ae657f5b513f875a15081cdcdc567b745480"
  head "https://github.com/nsqio/nsq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9cda7f1ff6361ba961adc79886f0d369419ed811e91f22b4b01a692d419a4a39" => :catalina
    sha256 "dfff1005e1c48d1669aafb79cb903ade485ceb9ebbb748d8a6f85f9f71a6ce7b" => :mojave
    sha256 "54c31bf18fcb185ca5a4dd0192ed846df8d5e6dccf5564d99252d3960555fe11" => :high_sierra
    sha256 "bcfcd2d5b6ef1bb767631be70ee5aa72bd5987ba3cc75df1043b24aaa08eac8e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/nsqio/nsq").install buildpath.children
    cd "src/github.com/nsqio/nsq" do
      system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
      prefix.install_metafiles
    end
  end

  def post_install
    (var/"log").mkpath
    (var/"nsq").mkpath
  end

  plist_options :manual => "nsqd -data-path=#{HOMEBREW_PREFIX}/var/nsq"

  def plist; <<~EOS
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
        <string>#{bin}/nsqd</string>
        <string>-data-path=#{var}/nsq</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/nsq</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/nsqd.error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/nsqd.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    begin
      lookupd = fork do
        exec bin/"nsqlookupd"
      end
      sleep 2
      d = fork do
        exec bin/"nsqd", "--lookupd-tcp-address=127.0.0.1:4160"
      end
      sleep 2
      admin = fork do
        exec bin/"nsqadmin", "--lookupd-http-address=127.0.0.1:4161"
      end
      sleep 2
      to_file = fork do
        exec bin/"nsq_to_file", "--lookupd-http-address=127.0.0.1:4161",
                                "--output-dir=#{testpath}",
                                "--topic=test"
      end
      sleep 2
      system "curl", "-d", "hello", "http://127.0.0.1:4151/pub?topic=test"
      sleep 2
      dat = File.read(Dir["*.dat"].first)
      assert_match "test", dat
      assert_match version.to_s, dat
    ensure
      Process.kill(15, lookupd)
      Process.kill(15, d)
      Process.kill(15, admin)
      Process.kill(15, to_file)
      Process.wait lookupd
      Process.wait d
      Process.wait admin
      Process.wait to_file
    end
  end
end
