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
    sha256 "aa282b6a0ef61c30a88f57431f468bab3d097a12bfb5a7be9de6321e342c0d4b" => :sierra
    sha256 "9b5f7fe96d0530669f9b7d2512457e3132da3599850e6b55e36164c8d52c0ee4" => :el_capitan
    sha256 "d0bbfd50655615cf2dff7257ab8645bc76ae250ec0871097435f3b7dfcd5e61c" => :yosemite
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
