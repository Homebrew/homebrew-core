class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
    :tag      => "v3.4.9",
    :revision => "54ba9589114fc3fa5cc36c313550b3c0c0938c91"
  head "https://github.com/etcd-io/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "603a74caf79959bbd42d482f81822a83eee9a7fa4a1614c989515649972d7743" => :catalina
    sha256 "d6d3304e5f3259a8299cbf79c369b86afe8a369ec293221611811dc716c4bca0" => :mojave
    sha256 "cf18cb41e9ee41ec20d5598a14756d231a2013c447b5406d1995e31d18137742" => :high_sierra
  end

  depends_on "go" => :build

  # remove in the next release
  patch do
    url "https://github.com/etcd-io/etcd/pull/11937.patch?full_index=1"
    sha256 "90f44278806323ddb8cc8160cb0bd00dd892698d90f27db505dca57e3c773df2"
  end

  def install
    # Fix vendored deps issue (remove this in the next release)
    system "go", "mod", "vendor"

    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
      bin/"etcd"
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
      bin/"etcdctl", "etcdctl/main.go"
    prefix.install_metafiles
  end

  plist_options :manual => "etcd"

  def plist
    <<~EOS
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
