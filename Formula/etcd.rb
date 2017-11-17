class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v3.2.10.tar.gz"
  sha256 "86b7afd78b3a409b23ddf9d889b74c4edecf0fec1148f83bf025911705895f08"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c19dd4821ad05695ef63a3e6fae78b9bcfe9c5f5fbbdf0c389f3d9f564b09af9" => :high_sierra
    sha256 "943fb9fa7f4b38988c2f111d409dfeeaf473b6f2bb2802adb4435569a50c44cd" => :sierra
    sha256 "b44d13c1ca349e4951c8eeafc02a1beff36ebdd1e1ea17e4041793f7971da374" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/coreos"
    ln_s buildpath, "src/github.com/coreos/etcd"
    system "./build"
    bin.install "bin/etcd"
    bin.install "bin/etcdctl"
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
        exec bin/"etcd", "--force-new-cluster", "--data-dir=#{testpath}"
      end
      # sleep to let etcd get its wits about it
      sleep 10
      etcd_uri = "http://127.0.0.1:2379/v2/keys/brew_test"
      system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
      curl_output = shell_output("curl --silent -L #{etcd_uri}")
      response_hash = JSON.parse(curl_output)
      assert_match(test_string, response_hash.fetch("node").fetch("value"))
    ensure
      # clean up the etcd process before we leave
      Process.kill("HUP", etcd_pid)
    end
  end
end
