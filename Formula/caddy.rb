require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.8.3.tar.gz"
  sha256 "e7d56c93315e5f114d5f1240bb8c98c129b65c79b774954902615d5a199128f2"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f691568e6d6f08442f06f448a0a46348ed10461cea75d0cdda52fe40a5774dcf" => :el_capitan
    sha256 "42b1e64f8cf84da3aba009fd5e24823106244d6d99c58d25563eeeb996edd616" => :yosemite
    sha256 "0bc99eebf7a40a3320e27bd9eb51ac3d5643591d236279565a89efacd6ce13ae" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "bbd5bb678321a0d6e58f1099321dfa73391c1b6f"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
    :revision => "fef948f2d241bd1fd0631108ecc2c9553bae60bf"
  end

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git",
    :revision => "3f9db97f856818214da2e1057f8ad84803971cff"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
    :revision => "1f512fc3f05332ba7117626cdfb4e07474e58e60"
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

  go_resource "github.com/mitchellh/goamz" do
    url "https://github.com/mitchellh/goamz.git",
    :revision => "caaaea8b30ee15616494ee68abd5d8ebbbef05cf"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
    :revision => "1d6b8e9301e720b08a8938b8c25c018285885438"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
    :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
    :revision => "e3f973b66b91445ec816dd7411ad1b6495a5a2fc"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git",
    :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "github.com/weppos/dnsimple-go" do
    url "https://github.com/weppos/dnsimple-go.git",
    :revision => "65c1ca73cb19baf0f8b2b33219b7f57595a3ccb0"
  end

  go_resource "github.com/xenolf/lego" do
    url "https://github.com/xenolf/lego.git",
    :revision => "96a24777ffb3c6a25f6bb0b3a7997969c1fcde4b"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "2c99acdd1e9b90d779ca23f632aad86af9909c62"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "a728288923b47049b2ce791836767ffbe964a5bd"
  end

  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://gopkg.in/natefinch/lumberjack.v2.git",
    :revision => "514cbda263a734ae8caac038dadf05f8f3f9f738"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
    :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    mkdir_p buildpath/"src/github.com/mholt/"
    ln_s buildpath, buildpath/"src/github.com/mholt/caddy"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X \"main.gitTag=#{version}\"", "-o", bin/"caddy"
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
