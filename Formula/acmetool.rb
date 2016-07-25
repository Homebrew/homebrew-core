require "language/go"

class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme/archive/v0.0.54.tar.gz"
  sha256 "470e5ebe3e28002d32d9f79e35b04d925c84bba33a89b67ad42cd970b924398a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bea5bc93662d074b0d1abeccbb3504e8676ed95f50c1fd58bd22eac1ccccbdc9" => :el_capitan
    sha256 "ac30c7f8e8ffe4b36efb4fba973292ffc02adcab4ce1284214caf87cc324b0e9" => :yosemite
    sha256 "8851dcc3b30468ca70bedb12c201a7d5eb20eb6e4a0805b02062a606a2aa5f5a" => :mavericks
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
      :revision => "b32b8467dbea18858bfebf65c1a6a761090f2c31"
  end

  go_resource "github.com/hlandau/degoutils" do
    url "https://github.com/hlandau/degoutils.git",
      :revision => "389a84765529fb80bf6fff3cdcdf814cbc42ee47"
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
      :revision => "879c5887cd475cd7864858769793b2ceb0d44feb"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
      :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "811831de4c4dd03a0b8737233af3b36852386373"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "b400c2eff1badec7022a8c8f5bea058b6315eed7"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://gopkg.in/alecthomas/kingpin.v2.git",
      :revision => "8cccfa8eb2e3183254457fb1749b2667fbc364c7"
  end

  go_resource "gopkg.in/cheggaaa/pb.v1" do
    url "https://gopkg.in/cheggaaa/pb.v1.git",
      :revision => "8808370bf63524e115da1371ba42bce6739f3a6b"
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
      :revision => "ecde8c8f16df93a994dda8936c8f60f0c26c28ab"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    (buildpath/"src/github.com/hlandau").mkpath
    ln_sf buildpath, buildpath/"src/github.com/hlandau/acme"
    Language::Go.stage_deps resources, buildpath/"src"

    # https://github.com/hlandau/acme/blob/master/_doc/PACKAGING-PATHS.md
    builddate = `date -u "+%Y%m%d%H%M%S"`.strip
    ldflags = <<-LDFLAGS
        -X github.com/hlandau/acme/storage.RecommendedPath=#{var}/lib/acmetool
        -X github.com/hlandau/acme/notify.DefaultHookPath=#{lib}/hooks
        -X github.com/hlandau/acme/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
        -X github.com/hlandau/degoutils/buildinfo.BuildInfo=v#{version}-#{builddate}-Homebrew
    LDFLAGS

    system "go", "build", "-o", bin/"acmetool", "-ldflags", ldflags,
        "github.com/hlandau/acme/cmd/acmetool"

    (man8/"acmetool.8").write Utils.popen_read(bin/"acmetool", "--help-man")

    doc.install "README.md", Dir["_doc/*"]
  end

  def post_install
    (var/"lib/acmetool").mkpath
    (var/"run/acmetool").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/acmetool --version", 2)
  end
end
