class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag      => "v1.7.2",
      :revision => "9ea1a204d832cfd4d8c5cba9df56876a526a4531"
  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "48d3dfc2bf8a652d9174272f441bcef15f6bef57c1a31e9825962fae52acd06d" => :catalina
    sha256 "2c321bc2005e2bef8825fa86c95755d36957c38c9c1ee44936bc201d14028802" => :mojave
    sha256 "6018791332232109b70c857748f49efb9d832c105f713d124a0f01e581668d5e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = "amd64"
    ENV["GOPATH"] = buildpath
    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/github.com/hashicorp/consul").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/consul" do
      system "make"
      bin.install "bin/consul"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "consul agent -dev -advertise 127.0.0.1"

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
            <string>#{opt_bin}/consul</string>
            <string>agent</string>
            <string>-dev</string>
            <string>-advertise</string>
            <string>127.0.0.1</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/consul.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/consul.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    fork do
      exec "#{bin}/consul", "agent", "-data-dir", "."
    end
    sleep 3
    system "#{bin}/consul", "leave"
  end
end
