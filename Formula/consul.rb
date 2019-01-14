class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag      => "v1.4.0",
      :revision => "0bddfa23a2ebe3c0773d917fc104f53d74f7a5ec"
  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "a106bef2a6dd84ffcb39f609ba9a182c0fe896e1946ce6975ad1894e7a3c56fd" => :mojave
    sha256 "2872d4822591f96abe68383cd465cfb6b9ee29aecf87eaa057e6503fead61d17" => :high_sierra
    sha256 "f8bae32cc832a7c94708ea5931c2387214db541ffc5fccbea15c8287b146cfa3" => :sierra
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
