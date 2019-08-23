class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
    :tag      => "v3.3.15",
    :revision => "94745a4eed0425653b3b4275a208d38babceeaec"
  head "https://github.com/etcd-io/etcd.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d7392e41874580ea26cccda6130072f8c360f2f4e6871042e20b9e7484b85214" => :mojave
    sha256 "4854e5c3bf7a4a4954b790113b926f6d5236807393fe275fccda37c4535d7f95" => :high_sierra
    sha256 "aac21ebafe3c042aebb31f832c7909ecfa54e5123e0fbafb261a173556c4aea4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
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
    ENV["ETCDCTL_API"] = "3"

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

      assert_equal "OK\n", shell_output("#{bin}/etcdctl put foo bar")
      assert_equal "foo\nbar\n", shell_output("#{bin}/etcdctl get foo 2>&1")
    ensure
      # clean up the etcd process before we leave
      Process.kill("HUP", etcd_pid)
    end
  end
end
