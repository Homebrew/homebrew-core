class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v1.0.5.tar.gz"
  sha256 "0e7dc07e4f61f9a00a4c962755098e19ebf8c8a8e0d72e311597ce021b7a2a5e"
  head "https://github.com/caddyserver/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56b98f2f38c4e1d3b1a2edfc1b972479e28196c44041d0680941f4a02049ba4f" => :catalina
    sha256 "a3a8216f2695e8a1e48bfda1b45958bb6cc0837f36366d8613175223c4811214" => :mojave
    sha256 "601e85a5ca5ca6194330d6e8818114bc8f46e11ab15590bc033ff068203b704b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    (buildpath/"src/github.com/caddyserver").mkpath
    ln_s buildpath, "src/github.com/caddyserver/caddy"

    system "go", "build", "-ldflags",
           "-X github.com/caddyserver/caddy/caddy/caddymain.gitTag=#{version}",
           "-o", bin/"caddy", "github.com/caddyserver/caddy/caddy"
  end

  plist_options :manual => "caddy -conf #{HOMEBREW_PREFIX}/etc/Caddyfile"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/caddy</string>
            <string>-conf</string>
            <string>#{etc}/Caddyfile</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    begin
      io = IO.popen("#{bin}/caddy")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    io.read =~ /0\.0\.0\.0:2015/
  end
end
