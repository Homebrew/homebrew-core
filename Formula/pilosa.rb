class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.8.4.tar.gz"
  sha256 "69d551acbd4031f6f858f5f4f3042a4e5623314f71f25b4e5efe3d73cfb08cd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe382296a001865617aaa70b1038d6958c91253c595e171a681ef9a0c7f1d8c0" => :high_sierra
    sha256 "23421b6abb66f3e830b4f10d40dc4835c7d26717e172ca0e8bdafa3ffd9a0e69" => :sierra
    sha256 "d77f70b27f82091fb4a9099ee5c081cb0e7499ca8632b06873b4719f537f0f9a" => :el_capitan
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
