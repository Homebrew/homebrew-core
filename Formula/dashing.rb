require "language/go"

class Dashing < Formula
  desc "Generate Dash documentation from HTML files"
  homepage "https://github.com/technosophos/dashing"
  url "https://github.com/technosophos/dashing/archive/0.3.0.tar.gz"
  sha256 "f6569f3df80c964c0482e7adc1450ea44532d8da887091d099ce42a908fc8136"
  head "https://github.com/technosophos/dashing.git"

  depends_on "go" => :build

  go_resource "github.com/andybalholm/cascadia" do
    url "https://github.com/andybalholm/cascadia.git"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :tag => "v1.20.0"
  end

  go_resource "github.com/mattn/go-sqlite3" do
    url "https://github.com/mattn/go-sqlite3.git",
        :tag => "v1.6.0"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :tag => "release-branch.go1.10",
        :revision => "0ed95abb35c445290478a5348a7b38bb154135fd"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "make", "build"
    bin.install "dashing"
  end

  test do
    system "#{bin}/dashing", "create"
    File.exist? "dashing.json"
  end
end
