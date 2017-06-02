class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.3.2.tar.gz"
  sha256 "12c5c5c2d511c655f02836e09d09cfafcb9eaa656a43850ddc6f6f9a2151b896"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9f0bb531a7c89f388792be61349d623e5a1e4101349a12cbf34904c6bfea3e6" => :sierra
    sha256 "2c6f9b38ef3881c07769d7ceb166b94f9af67ec8c8e2c8271b4ee61ed3e15489" => :el_capitan
    sha256 "91238f37a2d26db10541cc5ee2343c5c0ff114ac254cde88c0bca54f44d09c83" => :yosemite
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    require "time"
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/pilosa/"
    ln_s buildpath, buildpath/"src/github.com/pilosa/pilosa"
    system "glide", "install"
    system "go", "build", "-o", bin/"pilosa", "-ldflags",
           "-X github.com/pilosa/pilosa/cmd.Version=#{version}",
           "github.com/pilosa/pilosa/cmd/pilosa"
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
        exec "#{bin}/pilosa", "server", "--bind", "10101"
      end
      sleep 0.5
      assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
