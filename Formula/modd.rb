require "language/go"

class Modd < Formula
  desc "Flexible tool for responding to filesystem changes"
  homepage "https://github.com/cortesi/modd"
  url "https://github.com/cortesi/modd/archive/v0.3.tar.gz"
  sha256 "41d9e18e286f9de1b5919573cbf66bbcf0bf7e60b01bfe1d9608aabffba70ed4"
  head "https://github.com/cortesi/modd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0281f9cfc64de2f7d1160772163db8c3f778f8279e7a806ae80371f9dd863c3d" => :sierra
    sha256 "a828d6554f370950328513e5196f2e1778630a14dd91fb60ba71d977ad199f9a" => :el_capitan
    sha256 "49722bf8de3b711a914dffcf56fed69f1900ed4e179a7d415f8c132fe305aabb" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/GeertJohan/go.rice" do
    url "https://github.com/GeertJohan/go.rice.git",
        :revision => "0f3f5fde32fd1f755632a3d31ba2ec6d449e387b"
  end

  # go.rice dependencies
  go_resource "github.com/daaku/go.zipexe" do
    url "https://github.com/daaku/go.zipexe.git",
        :revision => "a5fe2436ffcb3236e175e5149162b41cd28bd27d"
  end

  go_resource "github.com/GeertJohan/go.incremental" do
    url "https://github.com/GeertJohan/go.incremental.git",
        :revision => "92fd0ce4a694213e8b3dfd2d39b16e51d26d0fbf"
  end

  go_resource "github.com/akavel/rsrc" do
    url "https://github.com/akavel/rsrc.git",
        :revision => "ba14da1f827188454a4591717fff29999010887f"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "6b9493b3cb60367edd942144879646604089e3f7"
  end

  # devd dependencies
  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc"
  end

  go_resource "github.com/bmatcuk/doublestar" do
    # v1.0.3
    url "https://github.com/bmatcuk/doublestar.git",
        :revision => "ec3b4af762f792cb93bf2518ff9ac408dbdc2b4e"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "533cd7fd8a85905f67a1753afb4deddc85ea174f"
  end

  go_resource "github.com/goji/httpauth" do
    url "https://github.com/goji/httpauth.git",
        :revision => "fc389c3003535723411032f2e9300889389e30fa"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "e2e3d8414d0fbae04004f151979f4e27c6747fe7"
  end

  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "77ed1c8a01217656d2080ad51981f6e99adaa177"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "d682a8f0cf139663a984ff12528da460ca963de9"
  end

  go_resource "github.com/rjeczalik/notify" do
    url "https://github.com/rjeczalik/notify.git",
        :revision => "5dd6205716539662f8f14ab513552b41eab69d5d"
  end

  go_resource "github.com/toqueteos/webbrowser" do
    # v1.0
    url "https://github.com/toqueteos/webbrowser.git",
        :revision => "21fc9f95c83442fd164094666f7cb4f9fdd56cd6"
  end

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
        :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
        :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "c197bcf24cde29d3f73c7b4ac6fd41f4384e8af6"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "9d8ef8d73b53840886e4a772c72f2b7d396cb37c"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    # v2.1.11
    url "https://github.com/alecthomas/kingpin.git",
        :revision => "8cccfa8eb2e3183254457fb1749b2667fbc364c7"
  end

  go_resource "github.com/cortesi/modd" do
    # v0.3
    url "https://github.com/cortesi/modd.git",
        :revision => "9383745c78c806f4d61096a1ff401433c30a4e14"
  end

  go_resource "github.com/cortesi/termlog" do
    url "https://github.com/cortesi/termlog.git",
        :revision => "898fe0decfa430637283eebf1fd19d4f6ce0a531"
  end

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/cortesi/"
    ln_sf buildpath, buildpath/"src/github.com/cortesi/modd"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "install", "github.com/GeertJohan/go.rice/rice"

    ENV.prepend_path "PATH", buildpath/"bin"

    system "rice", "embed-go"
    system "go", "build", "-o", "#{bin}/modd", "./cmd/modd"
    doc.install "README.md"
  end

  test do
    begin
      io = IO.popen("#{bin}/modd")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Error reading config file ./modd.conf", io.read
  end
end
