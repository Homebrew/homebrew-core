require "language/go"

class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.6.0.tar.gz"
  sha256 "6121066051ab55f266f2c891edcc66d449aa5786c8622f7f765015806ee6f84f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5beb89fe8f5d2a8834829a2d6b798d9a6329d05ccb349b060068c7263cf0ba84" => :sierra
    sha256 "56cc42c7ce67efb4632beeae0835d709eb3ff277c663da4b285afd0372ae9d24" => :el_capitan
    sha256 "d9808a26091e472ebf3a2d9bbd5afceeb339b64e8e7f5bbbae78fe9cf808a427" => :yosemite
  end

  depends_on "go" => :build
  depends_on "dep" => :build

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :revision => "25d6cab4d68d2a9b7c5965aa381726dd5dd6d7b8"
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
      system "make", "generate-statik", "pilosa", "FLAGS=-o #{bin}/pilosa", "VERSION=#{version}"
    end
  end

  plist_options :manual => "pilosa server"

  def plist; <<-EOS.undent
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
