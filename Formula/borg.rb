require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "https://github.com/ok-borg/borg"
  url "https://github.com/ok-borg/borg/archive/v0.0.3.tar.gz"
  sha256 "d90a55b9c25c2b1fa0c662f1f22fa79f19e77479ad10368756ddf2fa9bee21cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "64101a697ea132b7987ad365a92bc06bb0362963fd00d41589c3f12c07d05571" => :mojave
    sha256 "9fe24cedf3b86f48d3d70a22cd161145d690fb0592d6169ccc175e874a89a209" => :high_sierra
    sha256 "bd251596f570c3ec103d60ad04f78626c69a79cc20fe99f5bc483ffce12b695f" => :sierra
    sha256 "f88e6457bfdd91b124d18395f80c988ae0ef4020153f43028ccdfd4e5fdff0e8" => :el_capitan
    sha256 "4b4c4781a4b90104c1bda9243bb3d8f901eba9e57a3e2f2d923bf573e5065819" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "9131ab34cf20d2f6d83fdc67168a5430d1c7dc23"
  end

  go_resource "github.com/juju/gnuflag" do
    url "https://github.com/juju/gnuflag.git",
        :revision => "4e76c56581859c14d9d87e1ddbe29e1c0f10195f"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a3f3340b5840cee44f372bddb5880fcbc419b46a"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/ok-borg").mkpath
    ln_s buildpath, buildpath/"src/github.com/ok-borg/borg"
    system "go", "build", "-o", bin/"borg", "github.com/ok-borg/borg"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
