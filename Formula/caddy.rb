require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v1.0.0.tar.gz"
  sha256 "1c8b435a79e21b9832c7a8a88c44e70bc80434ca3719853d2b1092ffbbbbff7d"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27191a06eab88e00de8e26151d8dad30f64d6b4255d860feaa52db9e332df7be" => :mojave
    sha256 "815640cfb1d339447b762a8d79feb92c334d31553a894c921e7ed94467c06f47" => :high_sierra
    sha256 "e9a344ad86a981d5600d8e49f2a48f45c50ce8c964ce7397f3d122ed5d62edb8" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git",
        :revision => "3f9db97f856818214da2e1057f8ad84803971cff"
  end

  go_resource "github.com/google/uuid" do
    url "https://github.com/google/uuid.git",
        :revision => "0cd6bf5da1e1c83f8b45653022c74f71af0538a4"
  end

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/mholt/caddy"
    dir.install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd dir do
      system "go", "build", "-o", bin/"caddy"

      prefix.install_metafiles
    end
  end

  plist_options :manual => "caddy -conf #{HOMEBREW_PREFIX}/etc/Caddyfile"

  def plist; <<~EOS
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
