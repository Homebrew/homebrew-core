class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag => "v1.1.0",
      :revision => "5174058f0d2bda63fa5198ab96c33d9a909c58ed"

  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "ade3c8fcdabfeff4d80e117ad4bb5d7ae6283d267821e1db1832babc376b1d8d" => :high_sierra
    sha256 "f43e89d32840ea89158fbe6f2c6c6a6ee4299d2527a64893ede956c36b26e322" => :sierra
    sha256 "f82d247ef707dedad419c1ec78a48c3c75b624f82f8e4d360447828cede8e920" => :el_capitan
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
