require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "https://ok-b.org/"
  url "https://github.com/ok-borg/borg/archive/v0.0.3.tar.gz"
  sha256 "d90a55b9c25c2b1fa0c662f1f22fa79f19e77479ad10368756ddf2fa9bee21cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "194cb02cf318ae8341ba00119a9b6b4a855a75de60c7c51ccd6a7ee79fb87680" => :sierra
    sha256 "9ec849e3fead12d9fdb8f61881d6f7ea487e3b4839a307a7a1a2ff7d7a191a98" => :el_capitan
    sha256 "24b4bac6608cc3fe3e290760c06349f5f8b5b00876e2aa015a8c3d07be40b2fd" => :yosemite
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
