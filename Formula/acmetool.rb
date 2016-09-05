require "language/go"

class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme.git",
      :tag => "v0.0.58",
      :revision => "a4d55ea51a8782633d7ca477d24c5da9a5c6147b"

  bottle do
    sha256 "b5767527c07c989aeb07cd0e442af716df286dc598633b5b88955180f07da448" => :el_capitan
    sha256 "ecfea5ba3c74dd0725199ae56d4c9b280670dd3f3883854fbbc4dc7a5ddb831e" => :yosemite
    sha256 "2c5e9990f3efa9e2a858ab7864ccc355a8a75030d7efb6edf4270ebdffde3cf4" => :mavericks
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
        :revision => "43e4800a6165b4e02bb2a36673c54b230d6f7b26"
  end

  go_resource "github.com/hlandau/buildinfo" do
    url "https://github.com/hlandau/buildinfo.git",
        :revision => "b25d4b0e518fdb8bcbefaa3d52d77473bebe08fd"
  end

  go_resource "github.com/hlandau/dexlogconfig" do
    url "https://github.com/hlandau/dexlogconfig.git",
        :revision => "055e2e35f21ef605ada9e9af4e36597678678bf1"
  end

  go_resource "github.com/hlandau/goutils" do
    url "https://github.com/hlandau/goutils.git",
        :revision => "0cdb66aea5b843822af6fdffc21286b8fe8379c4"
  end

  go_resource "github.com/hlandau/xlog" do
    url "https://github.com/hlandau/xlog.git",
        :revision => "197ef798aed28e08ed3e176e678fda81be993a31"
  end

  go_resource "github.com/hlandauf/gspt" do
    url "https://github.com/hlandauf/gspt.git",
        :revision => "25f3bd3f5948489aa5f31c949310ae9f2b0e956c"
  end

  go_resource "github.com/jmhodges/clock" do
    url "https://github.com/jmhodges/clock.git",
        :revision => "880ee4c335489bc78d01e4d0a254ae880734bc15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "66b8e73f3f5cda9f96b69efd03dd3d7fc4a5cdb8"
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
        :revision => "d1cebc7ea14a5fc0de7cb4a45acae773161642c6"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "0aa62d5ddceb50dbcb909d790b5345affd3669b6"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "9e590154d2353f3f5e1b24da7275686040dcf491"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "1358eff22f0dd0c54fc521042cc607f6ff4b531a"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://gopkg.in/alecthomas/kingpin.v2.git",
        :revision => "e9044be3ab2a8e11d4e1f418d12f0790d57e8d70"
  end

  go_resource "gopkg.in/cheggaaa/pb.v1" do
    url "https://gopkg.in/cheggaaa/pb.v1.git",
        :revision => "9453b2db37f4d8bc63751daca63bbe7049eb5e74"
  end

  go_resource "gopkg.in/hlandau/configurable.v1" do
    url "https://gopkg.in/hlandau/configurable.v1.git",
        :revision => "41496864a1fe3e0fef2973f22372b755d2897402"
  end

  go_resource "gopkg.in/hlandau/easyconfig.v1" do
    url "https://gopkg.in/hlandau/easyconfig.v1.git",
        :revision => "bc5afaa18a1a72fe424da647d6bb57ca4d7f83c4"
  end

  go_resource "gopkg.in/hlandau/service.v2" do
    url "https://gopkg.in/hlandau/service.v2.git",
        :revision => "601cce2a79c1e61856e27f43c28ed4d7d2c7a619"
  end

  go_resource "gopkg.in/hlandau/svcutils.v1" do
    url "https://gopkg.in/hlandau/svcutils.v1.git",
        :revision => "88dbd6d288dcde4c17ea6048d9f3da23f263571c"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "139276ceb5afbf13e636c44e9382f0ca75c12ba3"
  end

  go_resource "gopkg.in/tylerb/graceful.v1" do
    url "https://gopkg.in/tylerb/graceful.v1.git",
        :revision => "50a48b6e73fcc75b45e22c05b79629a67c79e938"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "e4d366fc3c7938e2958e662b4258c7a89e1f0e3e"
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
