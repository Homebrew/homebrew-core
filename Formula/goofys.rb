require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  head "https://github.com/kahing/goofys.git"

  stable do
    url "https://github.com/kahing/goofys.git",
        :tag => "v0.0.12",
        :revision => "2f5cac015cb09482b60f0e9f7976ec353c5ad063"

    # Remove for > 0.0.12
    # Fix "case-insensitive import collision"
    # Upstream commit from 6 Jun 2017 "Lowercase github.com/Sirupsen/logrus"
    patch do
      url "https://github.com/kahing/goofys/commit/04ee797.patch"
      sha256 "a659701b9ae750cb387f3aa329a8e8054fc4fdcaa742487c985b8b3135ed8a19"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "37cc3d9237a36e90484421d906c68eca95948f9f5d3086bf44bd25e8c94c36e9" => :sierra
    sha256 "c31345dc6113a0870ec06717045fa2c046bd8c26947e26bd32f3c889a9481b2c" => :el_capitan
    sha256 "9ffae92c6b21080d0ea5a7589449913f271c0f988ca2f138c007ef0e2f282f00" => :yosemite
  end

  depends_on "go" => :build
  depends_on :osxfuse

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "85b1699d505667d13f8ac4478c1debbf85d6c5de"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "d70f47eeca3afd795160003bc6e28b001d60c67c"
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

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "3dd8bd46d9a1ccbd37b3ba6e3dc1dc7d37ba8dc5"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "59a0b19b5533c7977ddeb86b017bf507ed407b12"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "0b25a408a50076fbbcae6b7ac0ea5fbb0b085e79"
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
