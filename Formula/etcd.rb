class Etcd < Formula
  desc "Key value store for shared configuration and service discovery"
  homepage "https://github.com/coreos/etcd"
  url "https://github.com/coreos/etcd/archive/v3.2.8.tar.gz"
  sha256 "800dff80c28fdcf753d8819f0a531ad974742e204489ad0050e2601fd1379ee8"
  head "https://github.com/coreos/etcd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4e6e542ca128b3e0ad8103dd279e60427b8269e7f9ac2e0275938d11469a6e8" => :high_sierra
    sha256 "365df8c1ad176fa7e2850b3f513cdf277e6fad8d806f26f99c01f07d057e42b9" => :sierra
    sha256 "7846055325e39bf34f8b08ea75b600d2879ebf3d3cf1c48ab2ae20c31e5db47d" => :el_capitan
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
