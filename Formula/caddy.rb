require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.9.1.tar.gz"
  sha256 "c868e676042e88676c31188e0462b943618a24b3e264ad0512e77bc6cab38725"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc82434201964fc484d0b650949dbef54a048c3e41dd0ebc32a7b6a032a84e1d" => :el_capitan
    sha256 "d7f4ade61380d076b7a0f723fc4a72b1269e4c2f0a72688dc7ec0ccb649f4969" => :yosemite
    sha256 "dcb3e1f8a75f5212015157974be0b765381698e2cb4270acdf36303e4a3940fc" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "99064174e013895bbd9b025c31100bd1d9b590ca"
  end

  go_resource "github.com/dsnet/compress" do
    url "https://github.com/dsnet/compress.git",
        :revision => "b9aab3c6a04eef14c56384b4ad065e7b73438862"
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
        :revision => "a69d25be2fe2923a97c2af6849b2f52426f68fc0"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
        :revision => "315de0c1920b18b942603ffdc2229e2af4803c17"
  end

  go_resource "github.com/jimstudt/http-authentication" do
    url "https://github.com/jimstudt/http-authentication.git",
        :revision => "3eca13d6893afd7ecabe15f4445f5d2872a1b012"
  end

  go_resource "github.com/lucas-clemente/aes12" do
    url "https://github.com/lucas-clemente/aes12.git",
        :revision => "5a3c52721c1e81aa8162601ac2342486525156d5"
  end

  go_resource "github.com/lucas-clemente/fnv128a" do
    url "https://github.com/lucas-clemente/fnv128a.git",
        :revision => "393af48d391698c6ae4219566bfbdfef67269997"
  end

  go_resource "github.com/lucas-clemente/quic-go" do
    url "https://github.com/lucas-clemente/quic-go.git",
        :revision => "9de08f8913d8070e9e60f2c20233431d9fe1e914"
  end

  go_resource "github.com/lucas-clemente/quic-go-certificates" do
    url "https://github.com/lucas-clemente/quic-go-certificates.git",
        :revision => "4904164a1a6479e3b509f616ccd31a7b0e705d52"
  end

  go_resource "github.com/mholt/archiver" do
    url "https://github.com/mholt/archiver.git",
        :revision => "0231457b31435456e2df3da3f4a16c139da9fd5a"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "db96a2b759cdef4f11a34506a42eb8d1290c598e"
  end

  go_resource "github.com/nwaples/rardecode" do
    url "https://github.com/nwaples/rardecode.git",
        :revision => "f94841372ddc36be531a5c3e1206238e32e93d74"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
        :revision => "93622da34e54fb6529bfb7c57e710f37a8d9cbd8"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
        :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "github.com/xenolf/lego" do
    url "https://github.com/xenolf/lego.git",
        :revision => "823436d61175269716a88cd6627bfa603812f10c"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "88d0005bf4c3ec17306ecaca4281a8d8efd73e91"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "7394c112eae4dba7e96bfcfe738e6373d61772b4"
  end

  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://gopkg.in/natefinch/lumberjack.v2.git",
        :revision => "514cbda263a734ae8caac038dadf05f8f3f9f738"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "a3927f83df1b1516f9e9dec71839c93e6bcf1db0"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "e4d366fc3c7938e2958e662b4258c7a89e1f0e3e"
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
