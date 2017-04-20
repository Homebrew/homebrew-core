require "language/go"

class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme.git",
      :tag => "v0.0.59",
      :revision => "3201252d3de450a556a33daedbb55b95689eb248"

  bottle do
    sha256 "50d48558e978fd26e2ce3f80b0732cc03fcbd79f83fa0fac5476d63757c9e0ea" => :sierra
    sha256 "6412414b5280acd52b5e3801803b852add2d76c8a7873afc35ede86d3b7c5116" => :el_capitan
    sha256 "cbc086df6ca099afec97583c89dda7caa9bf8791f27811b4d3d1e0dc34dd6796" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
        :revision => "a0175ee3bccc567396460bf5acd36800cb10c49c"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
        :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "github.com/coreos/go-systemd" do
    url "https://github.com/coreos/go-systemd.git",
        :revision => "e97b35f834b17eaa82afe3d44715c34736bfa12b"
  end

  go_resource "github.com/hlandau/acme" do
    url "https://github.com/hlandau/acme.git",
        :revision => "3201252d3de450a556a33daedbb55b95689eb248"
  end

  go_resource "github.com/hlandau/buildinfo" do
    url "https://github.com/hlandau/buildinfo.git",
        :revision => "337a29b5499734e584d4630ce535af64c5fe7813"
  end

  go_resource "github.com/hlandau/dexlogconfig" do
    url "https://github.com/hlandau/dexlogconfig.git",
        :revision => "244f29bd260884993b176cd14ef2f7631f6f3c18"
  end

  go_resource "github.com/hlandau/goutils" do
    url "https://github.com/hlandau/goutils.git",
        :revision => "0cdb66aea5b843822af6fdffc21286b8fe8379c4"
  end

  go_resource "github.com/hlandau/xlog" do
    url "https://github.com/hlandau/xlog.git",
        :revision => "197ef798aed28e08ed3e176e678fda81be993a31"
  end

  go_resource "github.com/jmhodges/clock" do
    url "https://github.com/jmhodges/clock.git",
        :revision => "880ee4c335489bc78d01e4d0a254ae880734bc15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "dda3de49cbfcec471bd7a70e6cc01fcc3ff90109"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "14207d285c6c197daabb5c9793d63e7af9ab2d50"
  end

  go_resource "github.com/mitchellh/go-wordwrap" do
    url "https://github.com/mitchellh/go-wordwrap.git",
        :revision => "ad45545899c7b13c020ea92b2072220eefad42b8"
  end

  go_resource "github.com/ogier/pflag" do
    url "https://github.com/ogier/pflag.git",
        :revision => "45c278ab3607870051a2ea9040bb85fcb8557481"
  end

  go_resource "github.com/peterhellberg/link" do
    url "https://github.com/peterhellberg/link.git",
        :revision => "24c1495e8c97c8c537f23307b2b8d2932051c1a9"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "b061729afc07e77a8aa4fad0a2fd840958f1942a"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "453249f01cfeb54c3d549ddb75ff152ca243f9d8"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "b4690f45fa1cafc47b1c280c2e75116efe40cc13"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://gopkg.in/alecthomas/kingpin.v2.git",
        :revision => "e9044be3ab2a8e11d4e1f418d12f0790d57e8d70"
  end

  go_resource "gopkg.in/cheggaaa/pb.v1" do
    url "https://gopkg.in/cheggaaa/pb.v1.git",
        :revision => "d7e6ca3010b6f084d8056847f55d7f572f180678"
  end

  go_resource "gopkg.in/hlandau/configurable.v1" do
    url "https://gopkg.in/hlandau/configurable.v1.git",
        :revision => "41496864a1fe3e0fef2973f22372b755d2897402"
  end

  go_resource "gopkg.in/hlandau/easyconfig.v1" do
    url "https://gopkg.in/hlandau/easyconfig.v1.git",
        :revision => "33e53e2d08656ccad000531debbf2656a896b695"
  end

  go_resource "gopkg.in/hlandau/service.v2" do
    url "https://gopkg.in/hlandau/service.v2.git",
        :revision => "b64b3467ebd16f64faec1640c25e318efc0c0d7b"
  end

  go_resource "gopkg.in/hlandau/svcutils.v1" do
    url "https://gopkg.in/hlandau/svcutils.v1.git",
        :revision => "c25dac49e50cbbcbef8c81b089f56156f4067729"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "aa2e30fdd1fe9dd3394119af66451ae790d50e0d"
  end

  go_resource "gopkg.in/tylerb/graceful.v1" do
    url "https://gopkg.in/tylerb/graceful.v1.git",
        :revision => "4654dfbb6ad53cb5e27f37d99b02e16c1872fbbb"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a3f3340b5840cee44f372bddb5880fcbc419b46a"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/hlandau").mkpath
    ln_sf buildpath, buildpath/"src/github.com/hlandau/acme"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "cmd/acmetool" do
      # https://github.com/hlandau/acme/blob/master/_doc/PACKAGING-PATHS.md
      ldflags = %W[
        -X github.com/hlandau/acme/storage.RecommendedPath=#{var}/lib/acmetool
        -X github.com/hlandau/acme/hooks.DefaultPath=#{lib}/hooks
        -X github.com/hlandau/acme/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
        #{Utils.popen_read("#{buildpath}/src/github.com/hlandau/buildinfo/gen")}
      ]
      system "go", "build", "-o", bin/"acmetool", "-ldflags", ldflags.join(" ")
    end

    (man8/"acmetool.8").write Utils.popen_read(bin/"acmetool", "--help-man")

    doc.install Dir["_doc/*"]
  end

  def post_install
    (var/"lib/acmetool").mkpath
    (var/"run/acmetool").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acmetool --version", 2)
  end
end
