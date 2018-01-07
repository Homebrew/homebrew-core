class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.8.3.tar.gz"
  sha256 "ecf59f8296424e1661965430202d04e19ccb1cdfd595a66959f6665b16db31dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd3e69f7d165e6c65b4d673c9a3edd91c2195341205ed048868f458c9dc25976" => :high_sierra
    sha256 "05486cdc3bea99cef4a1ebeaad026576fde9c8e9ef51d2b0d8e62ebc3e10a5cf" => :sierra
    sha256 "ee9027e727a396959468fd8f22082d8d26a9bd42a78171f84c513a7ddc3d849d" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "go-statik" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children

    cd "src/github.com/pilosa/pilosa" do
      system "make", "generate-statik", "pilosa", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
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
      assert_match("<!DOCTYPE html>", shell_output("curl --user-agent NotCurl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
