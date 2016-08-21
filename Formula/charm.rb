require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/2.1.2.tar.gz"
  sha256 "09928a60bb4f7d8af3573ce269996417d6000e8e2bc769e4a7e6f451d264fc45"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f89fa2ab05754e0a813caef93ed739af18e96976fa2faaa83f5d4a8dc1ff39a" => :el_capitan
    sha256 "290e13e5e9d0cb573b4bb2cd1d974b570145e9eb7fbe4988417f590df6c28622" => :yosemite
    sha256 "0d0ec0323002d52cd1a148225d3876dc36f04e5ca40ed0b324ce888fb05d06f8" => :mavericks
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "94d5dba705240ba73ce5d65d83ce44adc749b440"
  end

  go_resource "github.com/rogpeppe/godeps" do
    url "https://github.com/rogpeppe/godeps.git",
        :revision => "c00f01a737f4f06e397ca86f67341cc345507221"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/juju/charmstore-client"
    dir.install buildpath.children - [buildpath/".brew_home"]
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/rogpeppe/godeps") { system "go", "install" }

    cd dir do
      system "godeps", "-x", "-u", "dependencies.tsv"
      system "go", "build", "github.com/juju/charmstore-client/cmd/charm"
      bin.install "charm"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/charm"
  end
end
