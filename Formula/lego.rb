require "language/go"

class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v0.5.0.tar.gz"
  sha256 "330b5da889422d4352e92f590a7d0eda79173d21c1e86914764e34018046c2be"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "31e0fc916eeba7f0d9afbd97737f5826d4cfcbda2398a005b8cedeec0902b274" => :high_sierra
    sha256 "2bf5ebd638eb8f6b3780c19020d2afa39b67aae6b50899fd91ec42e09b7d9898" => :sierra
    sha256 "73ba30cadb748f5ca76c1757634857af3ead4e1407a8c024d53d8eabbccff9f4" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "cloud.google.com/go" do
    url "https://code.googlesource.com/gocloud.git",
        :revision => "351ef39f1a2506de9d1786f4645566c400c4cb8e"
  end

  go_resource "github.com/Azure/azure-sdk-for-go" do
    url "https://github.com/Azure/azure-sdk-for-go.git",
        :revision => "0a8ed6c65dc34935d90dee3ddbc901f1f497f221"
  end

  go_resource "github.com/Azure/go-autorest" do
    url "https://github.com/Azure/go-autorest.git",
        :revision => "aa2a4534ab680e938d933870f58f23f77e0e208e"
  end

  go_resource "github.com/JamesClonk/vultr" do
    url "https://github.com/JamesClonk/vultr.git",
        :revision => "164aa254b818fbb0d505b1141950a59414856d37"
  end

  go_resource "github.com/akamai/AkamaiOPEN-edgegrid-golang" do
    url "https://github.com/akamai/AkamaiOPEN-edgegrid-golang.git",
        :revision => "196fbdab2db66d0e231cc363efb63454f55fed1c"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "0007fb4a03ff49ce86e2f3f9857514707ecddb0f"
  end

  go_resource "github.com/decker502/dnspod-go" do
    url "https://github.com/decker502/dnspod-go.git",
        :revision => "83a3ba562b048c9fc88229408e593494b7774684"
  end

  go_resource "github.com/dgrijalva/jwt-go" do
    url "https://github.com/dgrijalva/jwt-go.git",
        :revision => "06ea1031745cb8b3dab3f6a236daf2b0aa468b7e"
  end

  go_resource "github.com/dnsimple/dnsimple-go" do
    url "https://github.com/dnsimple/dnsimple-go.git",
        :revision => "bbe1a2c87affea187478e24d3aea3cac25f870b3"
  end

  go_resource "github.com/edeckers/auroradnsclient" do
    url "https://github.com/edeckers/auroradnsclient.git",
        :revision => "1563e622aaca0a8bb895a448f31d4a430ab97586"
  end

  go_resource "github.com/exoscale/egoscale" do
    url "https://github.com/exoscale/egoscale.git",
        :revision => "d65fce3f9a22bffbeb04ab491a23991e93c45b0f"
  end

  go_resource "github.com/go-ini/ini" do
    url "https://github.com/go-ini/ini.git",
        :revision => "06f5f3d67269ccec1fe5fe4134ba6e982984f7f5"
  end

  go_resource "github.com/google/go-querystring" do
    url "https://github.com/google/go-querystring.git",
        :revision => "53e6ce116135b80d037921a7fdd5138cf32d7a8a"
  end

  go_resource "github.com/google/uuid" do
    url "https://github.com/google/uuid.git",
        :revision => "dec09d789f3dba190787f8b4454c7d3c936fed9e"
  end

  go_resource "github.com/jinzhu/copier" do
    url "https://github.com/jinzhu/copier.git",
        :revision => "7e38e58719c33e0d44d585c4ab477a30f8cb82dd"
  end

  go_resource "github.com/json-iterator/go" do
    url "https://github.com/json-iterator/go.git",
        :revision => "8744d7c5c7b40a53e018f78d8c508b3315260b96"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "8ccae88257a8cec016f407e36517a0861e33dda8"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "3864e76763d94a6df2f9960b16a20a33da9f9a66"
  end

  go_resource "github.com/modern-go/concurrent" do
    url "https://github.com/modern-go/concurrent.git",
        :revision => "bacd9c7ef1dd9b15be4a9909b8ac7a4e313eec94"
  end

  go_resource "github.com/modern-go/reflect2" do
    url "https://github.com/modern-go/reflect2.git",
        :revision => "58118c1ea9161250907268a484af4dd6ed314280"
  end

  go_resource "github.com/namedotcom/go" do
    url "https://github.com/namedotcom/go.git",
        :revision => "08470befbe04613bd4b44cb6978b05d50294c4d4"
  end

  go_resource "github.com/ovh/go-ovh" do
    url "https://github.com/ovh/go-ovh.git",
        :revision => "91b7eb631d2eced3e706932a0b36ee8b5ee22e92"
  end

  go_resource "github.com/pkg/errors" do
    url "https://github.com/pkg/errors.git",
        :revision => "816c9085562cd7ee03e7f8188a1cfd942858cded"
  end

  go_resource "github.com/rainycape/memcache" do
    url "https://github.com/rainycape/memcache.git",
        :revision => "1031fa0ce2f20c1c0e1e1b51951d8ea02c84fa05"
  end

  go_resource "github.com/sirupsen/logrus" do
    url "https://github.com/sirupsen/logrus.git",
        :revision => "ea8897e79973357ba785ac2533559a6297e83c44"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "c679ae2cc0cb27ec3293fea7e254e47386f05d69"
  end

  go_resource "github.com/timewasted/linode" do
    url "https://github.com/timewasted/linode.git",
        :revision => "37e84520dcf74488f67654f9c775b9752c232dc1"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "8e01ec4cd3e2d84ab2fe90d8210528ffbb06d8ff"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "ab813273cd59e1333f7ae7bff5d027d4aadf528c"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "89e543239a64caf31d3a6865872ea120b41446df"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
        :revision => "ec22f46f877b4505e0117eeaab541714644fdd28"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "c11f84a56e43e20a78cee75a7c034031ecf57d1f"
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
        :revision => "de6fadef861e6dbf0af2a8d98d6c1389aaa28ca5"
  end

  go_resource "gopkg.in/ini.v1" do
    url "https://gopkg.in/ini.v1.git",
        :revision => "06f5f3d67269ccec1fe5fe4134ba6e982984f7f5"
  end

  go_resource "gopkg.in/ns1/ns1-go.v2" do
    url "https://gopkg.in/ns1/ns1-go.v2.git",
        :revision => "a5bcac82d3f637d3928d30476610891935b2d691"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "6e50787b7338112747e64f32753fb4f9dbfb8f79"
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
