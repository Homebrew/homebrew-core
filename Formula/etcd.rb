class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/etcd-io/etcd"
  url "https://github.com/etcd-io/etcd.git",
    tag:      "v3.4.12",
    revision: "17cef6e3e9d57c8c9d6a6afadcc3ff12c9279217"
  license "Apache-2.0"
  head "https://github.com/etcd-io/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e64dd2aa6a4f8a3b4476b16a74fd0187a675470e3386c84041374368be8d796f" => :catalina
    sha256 "ba7f5fb7daa1e20b167983ecf293c611c5bdb3a5acb0cf1cb1cfd60e19471213" => :mojave
    sha256 "05f9f749866691321ca6d31ceed84daabc740defe2997314e6829e832f5e1f1f" => :high_sierra
  end

  depends_on "go" => :build

  # See https://github.com/etcd-io/etcd/pull/11937
  patch do
    url "https://github.com/etcd-io/etcd/commit/45297c8790bef13baf5b905b3927029a701848c4.patch?full_index=1"
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

  plist_options manual: "etcd"

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
