require "language/go"

class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v1.3.tar.gz"
  sha256 "606a8b760bc498f9605423b4ef3b093fbb07fead5877a0da81b1c92d8af3ebbb"
  head "https://github.com/OJ/gobuster.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7da053cb4f0a73f55dc0cfaeea6628422e214e29c76a3f82c6ebe58faa2fe659" => :sierra
    sha256 "2499eb9e86e59b87640cc93fe8270be64cb1b5ce2a7e5a8d5a0bdcf69e68f054" => :el_capitan
    sha256 "4d781dd4d6bf9b3217d5d197b987583392ba8b6a4abc539720360041779889aa" => :yosemite
  end

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
