require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "https://ok-b.org/"
  url "https://github.com/crufter/borg/archive/v0.0.2.tar.gz"
  sha256 "e1b24f34a5b391e910af5aa903a376106c6328389b0accadbca231822ca1ff32"

  bottle do
    cellar :any_skip_relocation
    sha256 "194cb02cf318ae8341ba00119a9b6b4a855a75de60c7c51ccd6a7ee79fb87680" => :sierra
    sha256 "9ec849e3fead12d9fdb8f61881d6f7ea487e3b4839a307a7a1a2ff7d7a191a98" => :el_capitan
    sha256 "24b4bac6608cc3fe3e290760c06349f5f8b5b00876e2aa015a8c3d07be40b2fd" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/juju/gnuflag" do
    url "https://github.com/juju/gnuflag.git",
        :revision => "4e76c56581859c14d9d87e1ddbe29e1c0f10195f"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "a5b47d31c556af34a302ce5d659e6fea44d90de0"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/crufter").mkpath
    ln_s buildpath, buildpath/"src/github.com/crufter/borg"
    system "go", "build", "-o", bin/"borg", "github.com/crufter/borg"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
