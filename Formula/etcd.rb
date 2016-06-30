class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v2.3.6.tar.gz"
  sha256 "2d2f715fbe3aad679077d45e93a05a4b951811964e1e47ad7eba6e17d1d613a8"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "59ce397905777b9ba8bf16bde4b688a324d5cf8178af783eaaa3d42ba110e35a" => :el_capitan
    sha256 "696d1b52ee701451fb4ce950bbc0026b44817595eb01ca0fb8fb19fb813a1bf1" => :yosemite
    sha256 "77e16e9d78546f5dd81d452afeae71828f7a239d47993cc5edaf457315f616b8" => :mavericks
  end

  devel do
    url "https://github.com/coreos/etcd/archive/v3.0.0-beta.0.tar.gz"
    version "3.0.0-beta.0"
    sha256 "613c958a7ed9bb92069a46d5fc972a3c2b38b571ede475f88a5803f1f7bff1b3"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/etcd"
    bin.install "bin/etcdctl"
  end

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
        exec "etcd", "--force-new-cluster", "--data-dir=#{testpath}"
      end
      # sleep to let etcd get its wits about it
      sleep 10
      etcd_uri = "http://127.0.0.1:4001/v2/keys/brew_test"
      system "curl", "--silent", "-L", etcd_uri, "-XPUT", "-d", "value=#{test_string}"
      curl_output = shell_output "curl --silent -L #{etcd_uri}"
      response_hash = Utils::JSON.load(curl_output)
      assert_match(test_string, response_hash.fetch("node").fetch("value"))
    ensure
      # clean up the etcd process before we leave
      Process.kill("HUP", etcd_pid)
    end
  end
end
