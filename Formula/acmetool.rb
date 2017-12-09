require "language/go"

class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme.git",
      :tag => "v0.0.62",
      :revision => "2c2e661404c54478d8086ae8f792de0fdddbaed0"

  bottle do
    sha256 "9c22ea8e1080a6ce8b1ffefaa330207866d65a237de7f4666da703f0f4c07a01" => :high_sierra
    sha256 "288ccfd08f5208d3b03e3139872a273b3678d2ec98f2e432446ec3359fd28662" => :sierra
    sha256 "5725359701aceb2f0a4cf4acd9e5e15dd6224a11133372a432daeb2b985de6b6" => :el_capitan
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
        :revision => "c966a8af8422394b2e370d90e2101adba21c14be"
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
        :revision => "6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
        :revision => "97311d9f7767e3d6f422ea06661bc2c7a19e8a5d"
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
        :revision => "3eea38ca14b7b3252feea5daf92be3864209eb1d"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "5bf94b69c6b68ee1b541973bb8e1144db23a194b"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "94eea52f7b742c7cbe0b03b22f0c4c8631ece122"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "dc871a5d77e227f5bbf6545176ef3eeebf87e76e"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "3b24cac7bc3a458991ab409aa2a339ac9e0d60d6"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://gopkg.in/alecthomas/kingpin.v2.git",
        :revision => "1087e65c9441605df944fb12c33f0fe7072d18ca"
  end

  go_resource "gopkg.in/cheggaaa/pb.v1" do
    url "https://gopkg.in/cheggaaa/pb.v1.git",
        :revision => "657164d0228d6bebe316fdf725c69f131a50fb10"
  end

  go_resource "gopkg.in/hlandau/configurable.v1" do
    url "https://gopkg.in/hlandau/configurable.v1.git",
        :revision => "41496864a1fe3e0fef2973f22372b755d2897402"
  end

  go_resource "gopkg.in/hlandau/easyconfig.v1" do
    url "https://gopkg.in/hlandau/easyconfig.v1.git",
        :revision => "7589cb96edce2f94f8c1e6eb261f8c2b06220fe7"
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
        :revision => "287cf08546ab5e7e37d55a84f7ed3fd1db036de5"
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
