class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v3.0.3.tar.gz"
  sha256 "2e7ffb640da321df5e4efff378e3cc3329465d97c2abea8bee0c108d6536bf2e"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d60d1c658cf5ec716504cf2c011bc7f0ebff5297a1a06e58a2dd21dd411cbe39" => :el_capitan
    sha256 "09629e0e325365242a4c8039d8874ec5a6fb4db9e1c0aa4864cfa236b1540587" => :yosemite
    sha256 "475951fc4ce0bee3dd11e4c1d68c53c2a0b5c415cce888f391e4e0d55adced16" => :mavericks
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
      require "utils/json"
      test_string = "Hello from brew test!"
      etcd_pid = fork do
        exec bin/"etcd", "--force-new-cluster", "--data-dir=#{testpath}"
      end
      # sleep to let etcd get its wits about it
      sleep 10
      etcd_uri = "http://127.0.0.1:2379/v2/keys/brew_test"
      system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
      curl_output = shell_output("curl --silent -L #{etcd_uri}")
      response_hash = Utils::JSON.load(curl_output)
      assert_match(test_string, response_hash.fetch("node").fetch("value"))
    ensure
      # clean up the etcd process before we leave
      Process.kill("HUP", etcd_pid)
    end
  end
end
