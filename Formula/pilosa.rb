class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.8.6.tar.gz"
  sha256 "4f496afac23143edda50de1af5cccd237e51d5c63d0b7100e551a43299c9dc86"

  bottle do
    cellar :any_skip_relocation
    sha256 "27cb94c0e4ce606c16c369564e62d7dd93745292c1de579d35b8eec424cdd75b" => :high_sierra
    sha256 "d2b1e430a0df5e029d5fa059e07aae192abb6f32bb3f334c557f27e73b125234" => :sierra
    sha256 "01aeaa05a694754d214a81b213813ea8a56cf3f9194dc3085d37273a61a6e707" => :el_capitan
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
