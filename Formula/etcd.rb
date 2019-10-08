class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
    :tag      => "v3.4.1",
    :revision => "a14579fbfb1a000439a40abf71862df51b0a2136"
  head "https://github.com/etcd-io/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad02b0054cfff8ffb021915845e9275ffa761c5c66c9e90c1087a610ee31d592" => :catalina
    sha256 "6eb309f63e71d5826843ebfee393ccd72367ae29337c8d7acfb72ea1cf9ff394" => :mojave
    sha256 "d98cf8dc5ab321719e0404db05fde51dd2016fdf2180d83e9344d2d874af07cc" => :high_sierra
    sha256 "c39da2015d128534669617758122dd9aee9cb187aadb80d5a3e0ecb48d66b060" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/etcd-io/etcd"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"etcd"
      system "go", "build", "-ldflags", "-X main.version=#{version}", "-o", bin/"etcdctl", "etcdctl/main.go"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "etcd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/etcd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    begin
      test_string = "Hello from brew test!"
      etcd_pid = fork do
        exec bin/"etcd",
          "--enable-v2", # enable etcd v2 client support
          "--force-new-cluster",
          "--logger=zap", # default logger (`capnslog`) to be deprecated in v3.5
          "--data-dir=#{testpath}"
      end
      # sleep to let etcd get its wits about it
      sleep 10

      etcd_uri = "http://127.0.0.1:2379/v2/keys/brew_test"
      system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
      curl_output = shell_output("curl --silent -L #{etcd_uri}")
      response_hash = JSON.parse(curl_output)
      assert_match(test_string, response_hash.fetch("node").fetch("value"))

      assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
      assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
    ensure
      # clean up the etcd process before we leave
      Process.kill("HUP", etcd_pid)
    end
  end
end
