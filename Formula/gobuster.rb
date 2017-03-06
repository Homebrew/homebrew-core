require "language/go"

class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v1.3.tar.gz"
  sha256 "606a8b760bc498f9605423b4ef3b093fbb07fead5877a0da81b1c92d8af3ebbb"
  head "https://github.com/OJ/gobuster.git"

  depends_on "go" => :build

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "b061729afc07e77a8aa4fad0a2fd840958f1942a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "40541ccb1c6e64c947ed6f606b8a6cb4b67d7436"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/OJ").mkpath
    ln_sf buildpath, buildpath/"src/github.com/OJ/gobuster"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gobuster"
  end

  test do
    assert_match(/\[!\] WordList \(-w\): Must be specified/, shell_output("#{bin}/gobuster -q"))
  end
end
