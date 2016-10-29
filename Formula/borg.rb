require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "http://ok-b.org"
  url "https://github.com/crufter/borg/archive/v0.0.2.tar.gz"
  sha256 "e1b24f34a5b391e910af5aa903a376106c6328389b0accadbca231822ca1ff32"

  bottle do
    cellar :any_skip_relocation
    sha256 "788af2a35baa8684d87c08af155e9f8e4337be8e17791037e6427bceff8c9e16" => :sierra
    sha256 "45ed751aded7f2473187e7c834c8f0504903907352200bb2df7484f7ccba276d" => :el_capitan
    sha256 "d94dd0f87690d6c0615832eee18d6141ee29973ecfcf114d5d4f5003d24547d9" => :yosemite
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
