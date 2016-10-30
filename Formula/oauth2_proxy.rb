require "language/go"

class Oauth2Proxy < Formula
  desc "Reverse proxy for authenticating users via OAuth 2 providers"
  homepage "https://github.com/bitly/oauth2_proxy"
  url "https://github.com/bitly/oauth2_proxy/archive/v2.1.tar.gz"
  sha256 "e9f23bedaca7ee1da24c2834337846ccc618f8e55c698ae8e94394924c93858a"
  head "https://github.com/bitly/oauth2_proxy.git"

  bottle do
    sha256 "6eb329e21c7cb6dccad6d03ac8d7260a3ff2ebc4f322d5ae5d8c390bbf697622" => :sierra
    sha256 "982baa090eaedfacbbf82ac94721ecd8c466fba96987638bfc94c7e898f65224" => :el_capitan
    sha256 "078a955570fd82bbaa4003e5869b5b5368f06e567d5ff3edef0ede524e4741e7" => :yosemite
    sha256 "6d8ad6797411db753926c7cfe5df394034cbdf9d574df71c0d35ce8e5febe261" => :mavericks
  end

  depends_on "go" => :build

  go_resource "cloud.google.com/go" do
    url "https://code.googlesource.com/gocloud.git",
        :revision => "34b7f5b9fef1f79d2953ca03a36a9b824a1c54af"
  end

  go_resource "github.com/18F/hmacauth" do
    url "https://github.com/18F/hmacauth.git",
        :revision => "9232a6386b737d7d1e5c1c6e817aa48d5d8ee7cd"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/bitly/go-simplejson" do
    url "https://github.com/bitly/go-simplejson.git",
        :revision => "aabad6e819789e569bd6aabf444c935aa9ba1e44"
  end

  go_resource "github.com/bmizerany/assert" do
    url "https://github.com/bmizerany/assert.git",
        :revision => "b7ed37b82869576c289d7d97fb2bbd8b64a0cb28"
  end

  go_resource "github.com/mreiferson/go-options" do
    url "https://github.com/mreiferson/go-options.git",
        :revision => "33795234b6f327f1be2d78a541893012362a4e06"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "9313baa13d9262e49d07b20ed57dceafcd7240cc"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
        :revision => "3c3a985cb79f52a3190fbc056984415ca6763d01"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "30de6d19a3bd89a5f38ae4028e23aaa5582648af"
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
        :revision => "a69f0f19d246419bb931b0ac8f4f8d3f3e6d4feb"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1.git",
        :revision => "a8a77c9133d2d6fd8334f3260d06f60e8d80a5fb"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/bitly"
    ln_s buildpath, "#{buildpath}/src/github.com/bitly/oauth2_proxy"

    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "#{bin}/oauth2_proxy"
    doc.install "README.md"
    (etc/"oauth2_proxy").install "contrib/oauth2_proxy.cfg.example"
  end

  def caveats; <<-EOS.undent
    #{etc}/oauth2_proxy/oauth2_proxy.cfg must be filled in.
    EOS
  end

  plist_options :manual => "oauth2_proxy"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/oauth2_proxy</string>
            <string>--config=#{etc}/oauth2_proxy/oauth2_proxy.cfg</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    require "socket"
    require "timeout"

    # Get an unused TCP port.
    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    pid = fork do
      exec "#{bin}/oauth2_proxy",
        "--client-id=testing",
        "--client-secret=testing",
        "--cookie-secret=testing",
        "--http-address=127.0.0.1:#{port}",
        "--upstream=file:///tmp",
        "-email-domain=*"
    end

    begin
      Timeout.timeout(10) do
        loop do
          Utils.popen_read "curl", "-s", "http://127.0.0.1:#{port}"
          break if $?.exitstatus.zero?
          sleep 1
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
