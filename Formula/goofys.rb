require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag => "v0.0.13",
      :revision => "9ba2bf3938464a92e0c3bbe36919938fc67f0839"
  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "05b9c356a3fa68746fdf7e2f82b80567aba078a34b3c0fcbbe4b5fbfccc03914" => :sierra
    sha256 "61b5088aa3eae805a9dcc58483a4a59fbc2b95737d551525f9389770a6cec27d" => :el_capitan
    sha256 "1fd955ceee7f6da1feadc193c37d036f0b22d63a2d4a7472b7aec32788d264bf" => :yosemite
  end

  depends_on "go" => :build
  depends_on :osxfuse

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "b892ba3809cd07fcf2b064e166b0c2e16e0147bd"
  end

  go_resource "github.com/jacobsa/fuse" do
    url "https://github.com/jacobsa/fuse.git",
        :revision => "fe7f3a55dcaa3a8f3d5ff6a85b16b62b7a2c446c"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "ae77be60afb1dcacde03767a8c37337fad28ac14"
  end

  go_resource "github.com/sevlyar/go-daemon" do
    url "https://github.com/sevlyar/go-daemon.git",
        :revision => "821596c79672d38b7923916e766363184c00079c"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "3dd8bd46d9a1ccbd37b3ba6e3dc1dc7d37ba8dc5"
  end

  go_resource "github.com/sirupsen/logrus" do
    url "https://github.com/sirupsen/logrus.git",
        :revision => "3d4380f53a34dcdc95f0c1db702615992b38d9a4"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "f6abca593680b2315d2075e0f5e2a9751e3f431a"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "8663ed5da4fd087c3cfb99a996e628b72e2f0948"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "90796e5a05ce440b41c768bd9af257005e470461"
  end

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/kahing/goofys").install contents

    ENV["GOPATH"] = gopath

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/kahing/goofys" do
      system "go", "build", "-o", "goofys"
      bin.install "goofys"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goofys", "--version"
  end
end
