require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.9.3.tar.gz"
  sha256 "ec2f6e708262f6474a48a3503a1fbfb6e05e050772c0639ec823edda5e467668"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4809556211683d5baa1a0197cb23a2844dc40691e1fa6c0f7e47a58158325f70" => :sierra
    sha256 "8c035eabe6c4113916c6ddd95fa143495e010aeb9a73ed4acd2450c8e501963e" => :el_capitan
    sha256 "37b9a9ef34b540669446160421448822bb4f3cfeabccec0f1ee1a3dc85eedf6d" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/dsnet/compress" do
    url "https://github.com/dsnet/compress.git",
        :revision => "b9aab3c6a04eef14c56384b4ad065e7b73438862"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "bd88f87ad3a420f7bcf05e90566fd1ceb351fa7f"
  end

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git",
        :revision => "3f9db97f856818214da2e1057f8ad84803971cff"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "2d1e4548da234d9cb742cc3628556fef86aafbac"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
        :revision => "315de0c1920b18b942603ffdc2229e2af4803c17"
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
        :revision => "8ee5b5610baca43b60ecfad586b3c40d92a96e0c"
  end

  go_resource "github.com/lucas-clemente/fnv128a" do
    url "https://github.com/lucas-clemente/fnv128a.git",
        :revision => "393af48d391698c6ae4219566bfbdfef67269997"
  end

  go_resource "github.com/lucas-clemente/quic-go" do
    url "https://github.com/lucas-clemente/quic-go.git",
        :revision => "06f09e9a1e56cf94f4c3080e7fd1d6ebde8ab91c"
  end

  go_resource "github.com/lucas-clemente/quic-go-certificates" do
    url "https://github.com/lucas-clemente/quic-go-certificates.git",
        :revision => "d2f86524cced5186554df90d92529757d22c1cb6"
  end

  go_resource "github.com/mholt/archiver" do
    url "https://github.com/mholt/archiver.git",
        :revision => "eb71e84c00a9158cceae5817af934a1f74aa707f"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "db96a2b759cdef4f11a34506a42eb8d1290c598e"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
        :revision => "6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
  end

  go_resource "github.com/naoina/toml" do
    url "https://github.com/naoina/toml.git",
        :revision => "751171607256bb66e64c9f0220c00662420c38e9"
  end

  go_resource "github.com/nwaples/rardecode" do
    url "https://github.com/nwaples/rardecode.git",
        :revision => "f94841372ddc36be531a5c3e1206238e32e93d74"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
        :revision => "35eb537633d9950afc8ae7bdf0edb6134584e9fc"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
        :revision => "1dba4b3954bc059efc3991ec364f9f9a35f597d2"
  end

  go_resource "github.com/xenolf/lego" do
    url "https://github.com/xenolf/lego.git",
        :revision => "f3cd0bfdeebbf2fff1893beafc156f979c3c1e41"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "84e98f45760e87786b7f24603b8166a6fa09811d"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "819f4c5391c3fa3e3f7dab092b388a396c6723a8"
  end

  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://gopkg.in/natefinch/lumberjack.v2.git",
        :revision => "514cbda263a734ae8caac038dadf05f8f3f9f738"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "aa2e30fdd1fe9dd3394119af66451ae790d50e0d"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a5b47d31c556af34a302ce5d659e6fea44d90de0"
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
