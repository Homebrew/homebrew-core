require "language/go"

class Borg < Formula
  desc "Terminal based search engine for bash commands"
  homepage "http://ok-b.org"
  url "https://github.com/crufter/borg/archive/v0.0.1.tar.gz"
  sha256 "4ee3028a3d6034bcf6f92396f2a7abc9ae562652f886551c33a91cb0fbae835d"

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

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/crufter").mkpath
    ln_s buildpath, buildpath/"src/github.com/crufter/borg"

    system "go", "build", "-o", bin/"borg", "./src/github.com/crufter/borg"
  end

  test do
    system "#{bin}/borg", "-p", "brew"
  end
end
