require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.3.tar.gz"
  sha256 "fbbecb2eed383fd9deb9177f899ba8c8ebf15f767f4fefa0cc558f07ed337260"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3599def6c5ed16198fb3d1deed6f9ec67bf241bce591cf4fc554980af3e26222" => :sierra
    sha256 "047eeb630d46755dde3e7a9d853fb774bb15268141b76a859b889e5eed844e29" => :el_capitan
    sha256 "417869a3c1854bdc76b8e2743403be544a8d5eac0f97a2a31d5d12d042f46ca1" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/codahale/aesnicheck" do
    url "https://github.com/codahale/aesnicheck.git",
        :revision => "349fcc471aaccc29cd074e1275f1a494323826cd"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "259d2a102b871d17f30e3cd9881a642961a1e486"
  end

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git",
        :revision => "3f9db97f856818214da2e1057f8ad84803971cff"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "a91eba7f97777409bc2c443f5534d41dd20c5720"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
        :revision => "b609c7d9de4658cded34a7336b90886c56f9dbdb"
  end

  go_resource "github.com/hashicorp/golang-lru" do
    url "https://github.com/hashicorp/golang-lru.git",
        :revision => "0a025b7e63adc15a622f29b0b2c4c3848243bbf6"
  end

  go_resource "github.com/jimstudt/http-authentication" do
    url "https://github.com/jimstudt/http-authentication.git",
        :revision => "3eca13d6893afd7ecabe15f4445f5d2872a1b012"
  end

  go_resource "github.com/lucas-clemente/aes12" do
    url "https://github.com/lucas-clemente/aes12.git",
        :revision => "25700e67be5c860bcc999137275b9ef8b65932bd"
  end

  go_resource "github.com/lucas-clemente/fnv128a" do
    url "https://github.com/lucas-clemente/fnv128a.git",
        :revision => "393af48d391698c6ae4219566bfbdfef67269997"
  end

  go_resource "github.com/lucas-clemente/quic-go" do
    url "https://github.com/lucas-clemente/quic-go.git",
        :revision => "8489c94f4d3aaa5feaa284a16376cfb8ea7d2c2c"
  end

  go_resource "github.com/lucas-clemente/quic-go-certificates" do
    url "https://github.com/lucas-clemente/quic-go-certificates.git",
        :revision => "d2f86524cced5186554df90d92529757d22c1cb6"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "f282f80e243cc2bf8f6410c30d821b93b794e168"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
        :revision => "6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
  end

  go_resource "github.com/naoina/toml" do
    url "https://github.com/naoina/toml.git",
        :revision => "e6f5723bf2a66af014955e0888881314cf294129"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
        :revision => "0ba0f2b6ed7c475a92e4df8641825cb7a11d1fa3"
  end

  go_resource "github.com/xenolf/lego" do
    url "https://github.com/xenolf/lego.git",
        :revision => "aaa8e70aec58a858b6bef0706b367dd5e8d58128"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "0fe963104e9d1877082f8fb38f816fcd97eb1d10"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "513929065c19401a1c7b76ecd942f9f86a0c061b"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "19e51611da83d6be54ddafce4a4af510cb3e9ea4"
  end

  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://gopkg.in/natefinch/lumberjack.v2.git",
        :revision => "dd45e6a67c53f673bb49ca8a001fd3a63ceb640e"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "aa2e30fdd1fe9dd3394119af66451ae790d50e0d"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "cd8b52f8269e0feb286dfeef29f8fe4d5b397e0b"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    (buildpath/"src/github.com/mholt").mkpath
    ln_s buildpath, "src/github.com/mholt/caddy"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags",
           "-X github.com/mholt/caddy/caddy/caddymain.gitTag=#{version}",
           "-o", bin/"caddy", "github.com/mholt/caddy/caddy"
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
