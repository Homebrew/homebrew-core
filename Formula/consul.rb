class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag      => "v1.6.1",
      :revision => "9be6dfc310ddd54627d698537a98827245185290"
  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "59a7bb6f11f3143312a84e602489983c40c4883a3b98ddc35d63024f31709b5f" => :mojave
    sha256 "568246b8bb2f34be03184e3f85dd86aed59bdf805f08f9cee975d862106a87a6" => :high_sierra
    sha256 "c0daf241f7c18b1a4e176049af8a61eabf44feb852ea817dfd32edd685d50d27" => :sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    # Avoid running `go get`
    inreplace "GNUmakefile", "go get -u -v $(GOTOOLS)", ""

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
