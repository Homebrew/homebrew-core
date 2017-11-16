require "language/go"

class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.8.1.tar.gz"
  sha256 "52ff3b46a4ba05a056afa96609d7f9c73b9b4650b5b4af54c1a0cea58907357b"

  bottle do
    cellar :any_skip_relocation
    sha256 "079f06f54ebaede4f007c6ac550dc8062f8319f2ab39cb6f79e43e2d149c0af6" => :high_sierra
    sha256 "8ce70bc300dfbe98ccdb11e73261f5b1b7a68c94b76dc89c542faf931d3da8ef" => :sierra
    sha256 "2b397ff34673843663cd608fbb90f12e48088a090ac2d64676bb1ed6ca3c811a" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "dep" => :build

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :tag => "v0.1.1"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_path "PATH", "#{buildpath}/bin"

    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/rakyll/statik" do
      system "go", "install"
    end
    cd "src/github.com/pilosa/pilosa" do
      system "make", "generate-statik", "pilosa", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
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
