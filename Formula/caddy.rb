require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.10.1.tar.gz"
  sha256 "c2b084c34f9bf67a3ed38a6b97db24b74109cca9f18ec19695a46f26c6f7ad0a"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "462dab6c851069c68fbe404f7ad9aa8df589d37715db0a79d98133efcfc9ae16" => :sierra
    sha256 "47c087f7e9e59cf3f2b090a9e9793d4e654158929d57cade67ead7c17353a5f1" => :el_capitan
    sha256 "eabefa0f6cafbc2624b570954e47ece1b802bc3a500917ee5cbb60ee74b29fdb" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/dsnet/compress" do
    url "https://github.com/dsnet/compress.git",
        :revision => "b9aab3c6a04eef14c56384b4ad065e7b73438862"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "259d2a102b871d17f30e3cd9881a642961a1e486"
  end

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git",
        :revision => "3f9db97f856818214da2e1057f8ad84803971cff"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
        :revision => "553a641470496b2327abcac10b36396bd98e45c9"
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
        :revision => "2674c9835963711795a608cfeed0bdbeeade1e7a"
  end

  go_resource "github.com/lucas-clemente/quic-go-certificates" do
    url "https://github.com/lucas-clemente/quic-go-certificates.git",
        :revision => "d2f86524cced5186554df90d92529757d22c1cb6"
  end

  go_resource "github.com/mholt/archiver" do
    url "https://github.com/mholt/archiver.git",
        :revision => "c55f48c22890807c9698370fe5e08eca3704834b"
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

  go_resource "github.com/nwaples/rardecode" do
    url "https://github.com/nwaples/rardecode.git",
        :revision => "f22b7ef81a0afac9ce1447d37e5ab8e99fbd2f73"
  end

  go_resource "github.com/pierrec/lz4" do
    url "https://github.com/pierrec/lz4.git",
        :revision => "f5b77fd73d83122495309c0f459b810f83cc291f"
  end

  go_resource "github.com/pierrec/xxHash" do
    url "https://github.com/pierrec/xxHash.git",
        :revision => "5a004441f897722c627870a981d02b29924215fa"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
        :revision => "b253417e1cb644d645a0a3bb1fa5034c8030127c"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
        :revision => "79c90efaf01eddc01945af5bc1797859189b830b"
  end

  go_resource "github.com/ulikunitz/xz" do
    url "https://github.com/ulikunitz/xz.git",
        :revision => "3807218c9f4ed05861fa9eb75b8fb8afd3325a34"
  end

  go_resource "github.com/xenolf/lego" do
    url "https://github.com/xenolf/lego.git",
        :revision => "b1fd84c6ffc6896cfd64eca69775bc634d459702"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "c7af5bf2638a1164f2eb5467c39c6cffbd13a02e"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "da118f7b8e5954f39d0d2130ab35d4bf0e3cb344"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "470f45bf29f4147d6fbd7dfd0a02a848e49f5bf4"
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
