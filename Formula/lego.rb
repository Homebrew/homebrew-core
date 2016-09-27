require "language/go"

class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v0.3.1.tar.gz"
  sha256 "628a0dfa7c02ba833056ad8077a0e391a6658f03ddeec51d3c9f3f937cb482ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fd4569f0ce6ee5240851f65f7c2703dbb77c1e8b0b8768e9e172b2ccf963ecb" => :sierra
    sha256 "e1188ec549f3d4c8821ab1aa750cfc8e8669ff22e885b897c8c51d7773801b7f" => :el_capitan
    sha256 "0a6710217b961063eb6f957daaece02024633378f616bd782d0ff6912a95cf19" => :yosemite
    sha256 "f12dea6a3f6ce208b1a9e512a51454578f5a273f3442b4797e8414068e055d74" => :mavericks
  end

  depends_on "go" => :build

  go_resource "cloud.google.com/go" do
    url "https://code.googlesource.com/gocloud.git",
        :revision => "49467e5deee2b3e98455bb834e029afc067d04f5"
  end

  go_resource "github.com/JamesClonk/vultr" do
    url "https://github.com/JamesClonk/vultr.git",
        :revision => "42d4701246e48d1b81b80471e418ea0d1cc99586"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "00e2bf9d1518c2b7d8a97eb05b5d2a9afd1dd34e"
  end

  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "77ed1c8a01217656d2080ad51981f6e99adaa177"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "db96a2b759cdef4f11a34506a42eb8d1290c598e"
  end

  go_resource "github.com/ovh/go-ovh" do
    url "https://github.com/ovh/go-ovh.git",
        :revision => "d2b2eae2511fa5fcd0bdef9f1790ea3979fa35d4"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "168c95418e66e019fe17b8f4f5c45aa62ff80e23"
  end

  go_resource "github.com/weppos/dnsimple-go" do
    url "https://github.com/weppos/dnsimple-go.git",
        :revision => "65c1ca73cb19baf0f8b2b33219b7f57595a3ccb0"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "611beeb3d5df450a45f4b67f9e25235f54beda72"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "57bfaa875b96fb91b4766077f34470528d4b03e9"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
        :revision => "04e1573abc896e70388bd387a69753c378d46466"
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
        :revision => "593853e2d377362656ee40abf6df5cd3030c736b"
  end

  go_resource "gopkg.in/ini.v1" do
    url "https://gopkg.in/ini.v1.git",
        :revision => "cf53f9204df4fbdd7ec4164b57fa6184ba168292"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "e3f973b66b91445ec816dd7411ad1b6495a5a2fc"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/xenolf").mkpath
    ln_s buildpath, buildpath/"src/github.com/xenolf/lego"

    system "go", "build", "-o", bin/"lego", "./src/github.com/xenolf/lego"
  end

  test do
    system bin/"lego", "-v"
  end
end
