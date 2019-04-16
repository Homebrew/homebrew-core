class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v1.3.0.tar.gz"
  sha256 "135d8cdefdac6dad95c603de385f552bded73f7929aa12f7e466addd95421a6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "af2081f3d7b881b14ced0d17f42816269e759ad52bf85eaa9f9590a0d43f3f2b" => :mojave
    sha256 "313aba3da14562d891fd95ec7323f10773af34137cd9b0810b21cd8ca832c9bb" => :high_sierra
    sha256 "6a60b386e7fa8539bffbf7b1082fb3add777a3f304508cb362d1c9913ddfd439" => :sierra
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
