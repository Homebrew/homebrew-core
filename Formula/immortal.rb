require "language/go"

class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.16.0.tar.gz"
  sha256 "b540882641b904be956ac0cf3a4a9cda9c5ea709c24b68c77c3f08a1a13272b6"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02f4489c2f01ee2b8255ff39e4ea31d1395e99fc1279b20079de883c62751933" => :sierra
    sha256 "a49c5e210b009a6dbbd662f16a89b650470a291f192058e1e88dc817397f1be5" => :el_capitan
    sha256 "b7b2835be2e0984d1e756312144e81029de34e1e83fbe7edf1eef8ae07ec392a" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/go-yaml/yaml" do
    url "https://github.com/go-yaml/yaml.git",
        :revision => "eb3733d160e74a9c7e442f435eb3bea458e1d19f"
  end

  go_resource "github.com/nbari/violetear" do
    url "https://github.com/nbari/violetear.git",
        :revision => "13cb9a63c0cb68977810a7f38ced9f93178d5d62"
  end

  go_resource "github.com/immortal/logrotate" do
    url "https://github.com/immortal/logrotate.git",
        :revision => "859105169067e6c76e08f888fb76cf4929fe9064"
  end

  go_resource "github.com/immortal/multiwriter" do
    url "https://github.com/immortal/multiwriter.git",
        :revision => "2555774a03ac1d12b5bb4392858959ee50f78884"
  end

  go_resource "github.com/immortal/natcasesort" do
    url "https://github.com/immortal/natcasesort.git",
        :revision => "69368b73881a69041466dd2b4fc0373f8e47db15"
  end

  go_resource "github.com/immortal/xtime" do
    url "https://github.com/immortal/xtime.git",
        :revision => "fb1aca1146ea82769e8433f5bb22f373765e7ecc"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/immortal/immortal").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/immortal/immortal" do
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
      man8.install Dir["man/*.8"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
