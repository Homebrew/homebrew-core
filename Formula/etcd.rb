class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v3.2.4.tar.gz"
  sha256 "e0ba8e9a0f0cc9631eadfcd4def78649d22e76e2f5b3d21b378466b306708d8b"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6b414904dfc3769b56941e8672695a72826873c4c18bbb0c6de5fd93f67cdee" => :sierra
    sha256 "08b5a2f2e149bc90cb923020d5261075d633520f52f6cbe660db20f0c6219d2c" => :el_capitan
    sha256 "74dbc905768ff13cda1f5365a628b9e590113d610444b3ab5cf78af7fc9ff905" => :yosemite
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

  def plist; <<-EOS.undent
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
