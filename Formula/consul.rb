class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag => "v1.2.0",
      :revision => "28141971f966e99916da2c5e461dd968746491cd"

  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "ecc3193fcb3c3af540e3bc74a3dc592e7dedb3b93238232b8e1fd28105e50302" => :high_sierra
    sha256 "847b1967a2d036a1e675299b9307236f1bb9dbfde22a406071500b80a9e17425" => :sierra
    sha256 "1939470ebb9bdf07e7cfbb5ff7509827852cf9ed719a770f5c1634f2a0c9ec11" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    # Avoid running `go get`
    inreplace "GNUmakefile", "go get -u -v $(GOTOOLS)", ""

    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
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
