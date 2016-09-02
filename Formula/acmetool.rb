require "language/go"

class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme.git",
      :tag => "v0.0.57",
      :revision => "3463e55a6b4c5f91b08fc909091184159a9f1679"

  bottle do
    sha256 "98d9ee797583ffaf9930271449e7477b9b2d270930268b0e97a6888de278f008" => :el_capitan
    sha256 "164e72b6921764504d5fa43e7e5ba8fddde375ad6de952692c212817d2364cee" => :yosemite
    sha256 "b16d27039ce9d67d5f6210e8c4fcec12e0166d14a09244dcbe40929cf4b71a35" => :mavericks
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
        :revision => "fa8411dcbcbad22b8542b0433914ef68b123f989"
  end

  go_resource "github.com/hlandau/buildinfo" do
    url "https://github.com/hlandau/buildinfo.git",
        :revision => "b25d4b0e518fdb8bcbefaa3d52d77473bebe08fd"
  end

  go_resource "github.com/hlandau/dexlogconfig" do
    url "https://github.com/hlandau/dexlogconfig.git",
        :revision => "6a5c36427a2898a4dfd91e2913804b58e5efe2bc"
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
        :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
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
        :revision => "7a1054f3ac58191481dc500077c6b060f5d6c7e5"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "7c62cfdcccc65f87b0120ec841012ba816fc1aec"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://gopkg.in/alecthomas/kingpin.v2.git",
        :revision => "e5900212cbf65b181d3d8e08308ef06a01d117cf"
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
        :revision => "09c5458e23bda3b8e4d925fd587bd44fbdb5950e"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "e3f973b66b91445ec816dd7411ad1b6495a5a2fc"
  end

  go_resource "gopkg.in/tylerb/graceful.v1" do
    url "https://gopkg.in/tylerb/graceful.v1.git",
        :revision => "c838c13b2beeea4f4f54496da96a3a6ae567c37a"
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

    cd "src/github.com/hlandau/acme/cmd/acmetool" do
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
