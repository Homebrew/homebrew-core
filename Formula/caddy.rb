require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.9.0.tar.gz"
  sha256 "ded8400281d5c7e3ab7765d3ee89740212e9d2b1323e111ef88f4fffc7e074b2"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e937a02255c4fae64ad55a368ec4927d3543dbc73dce6adcd3eb96c66a3fb393" => :el_capitan
    sha256 "f8d4ef9de9dc9c8f44f4120e255297747653a620bcd7329cbc31cd21d132d76f" => :yosemite
    sha256 "6639b2b51ab661a6970281effc3f21dc73c056f09fdbc4979d558191a3e9f7a9" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
    :revision => "2fcb5204cdc65b4bec9fd0a87606bb0d0e3c54e8"
  end

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git",
    :revision => "3f9db97f856818214da2e1057f8ad84803971cff"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
    :revision => "5e2e56d5dfd46884df1036f828777ee6273f2cff"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
    :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/jimstudt/http-authentication" do
    url "https://github.com/jimstudt/http-authentication.git",
    :revision => "3eca13d6893afd7ecabe15f4445f5d2872a1b012"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
    :revision => "5d001d020961ae1c184f9f8152fdc73810481677"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
    :revision => "93622da34e54fb6529bfb7c57e710f37a8d9cbd8"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
    :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
    :revision => "e3f973b66b91445ec816dd7411ad1b6495a5a2fc"
  end

  go_resource "github.com/xenolf/lego" do
    url "https://github.com/xenolf/lego.git",
    :revision => "b12ce5e73146e74520c426895394b92dffeb3a25"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "911fafb28f4ee7c7bd483539a6c96190bbbccc3f"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "4d38db76854b199960801a1734443fd02870d7e1"
  end

  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://gopkg.in/natefinch/lumberjack.v2.git",
    :revision => "514cbda263a734ae8caac038dadf05f8f3f9f738"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
    :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  go_resource "github.com/lucas-clemente/quic-go" do
    url "https://github.com/lucas-clemente/quic-go.git",
    :revision => "6ea4f4b6e386dd46e95201abcfeda4e238495061"
  end

  go_resource "github.com/aead/chacha20" do
    url "https://github.com/aead/chacha20.git",
    :revision => "88f11922ed7bdc7abc8ce27232ef5b3d478d96fe"
  end

  go_resource "github.com/aead/poly1305" do
    url "https://github.com/aead/poly1305.git",
    :revision => "ac90e6e7a3b896d689165a10a71403a0ed6906e9"
  end

  go_resource "github.com/lucas-clemente/aes12" do
    url "https://github.com/lucas-clemente/aes12.git",
    :revision => "a5fc7687b08b4d6779efc82942708b72510c4f37"
  end

  go_resource "github.com/lucas-clemente/fnv128a" do
    url "https://github.com/lucas-clemente/fnv128a.git",
    :revision => "393af48d391698c6ae4219566bfbdfef67269997"
  end

  go_resource "github.com/lucas-clemente/quic-go-certificates" do
    url "https://github.com/lucas-clemente/quic-go-certificates.git",
    :revision => "9bb36d3159787cca26dcfa15e23049615e307ef8"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    mkdir_p buildpath/"src/github.com/mholt/"
    ln_s buildpath, buildpath/"src/github.com/mholt/caddy"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "caddy" do
      system "go", "build", "-ldflags", "-X \"github.com/mholt/caddy/caddy/caddymain.gitTag=#{version}\"", "-o", bin/"caddy"
    end
    doc.install %w[README.md LICENSE.txt]
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
