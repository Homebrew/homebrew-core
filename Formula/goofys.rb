require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag => "v0.0.11",
      :revision => "f8874334db1342fd90495afb1619ed188699f25c"

  head "https://github.com/kahing/goofys.git"

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
        :revision => "5e5dc898656f695e2a086b8e12559febbfc01562"
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
        :revision => "1ae26ef5036ad04968706917222a23c535673d8c"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "3e0b91b57e3af799519f9df577f4a27235e004d2"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
        :revision => "7dcfb8076726a3fdd9353b6b8a1f1b6be6811bd6"
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
