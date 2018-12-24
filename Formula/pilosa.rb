class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v1.2.0.tar.gz"
  sha256 "3497808a698c83ac4b29a6597fef2e78c59d4a2d5cda55bb03e94f9763c206c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7e431a20b9e90a0dc0e22218956bba6bbbd2e1c8c99ccbbb65b527f1fe06442" => :mojave
    sha256 "e63c7d2de244ca57b2b6032901ff9a99eb6a0335f1738d6e832d8f03ceb85ea7" => :high_sierra
    sha256 "0dad658a2c78686af07c7012870541ca193b1d2189f3a0122a1356076f23614b" => :sierra
    sha256 "fe22b919c424b81169929e3be5f675f53a337ab52c5d47bd762dfadb5b130b34" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children

    cd "src/github.com/pilosa/pilosa" do
      system "make", "build", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "pilosa server"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/pilosa</string>
            <string>server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
            <key>SuccessfulExit</key>
            <false/>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    begin
      server = fork do
        exec "#{bin}/pilosa", "server"
      end
      sleep 0.5
      assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
