require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag => "v0.19.0",
      :revision => "943e017724ea820eb4185419ef3c41d6f921a324"
  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce3fd9f0c78c10283136889115b3ce94000f94717ac31d30caccb2c9802042cd" => :high_sierra
    sha256 "500ebbe25ea404a4af82aca0fc5d1996563a8f3814511b32dfbfb6f17b998c71" => :sierra
    sha256 "274821789a943168c8cd2cabeeaca1a880f49c2c627da2306824a622613f8f61" => :el_capitan
  end

  depends_on "go" => :build
  depends_on :osxfuse

  go_resource "github.com/jacobsa/fuse" do
    url "https://github.com/jacobsa/fuse.git",
        :revision => "c4e473376f7d5be650b11657ded3afb1cd80ad7c"
  end

  go_resource "github.com/jinzhu/copier" do
    url "https://github.com/jinzhu/copier.git",
        :revision => "db4671f3a9b8df855e993f7c94ec5ef1ffb0a23b"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "ae77be60afb1dcacde03767a8c37337fad28ac14"
  end

  go_resource "github.com/sevlyar/go-daemon" do
    url "https://github.com/sevlyar/go-daemon.git",
        :revision => "e49ef56654f54139c4dc0285f973f74e9649e729"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "2ae56c34ce208b38309ab1618fc82866a1051811"
  end

  go_resource "github.com/sirupsen/logrus" do
    url "https://github.com/sirupsen/logrus.git",
        :revision => "d682213848ed68c0a260ca37d6dd5ace8423f5ba"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "75104e932ac2ddb944a6ea19d9f9f26316ff1145"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "0fcca4842a8d74bfddc2c96a073bd2a4d2a7a2e8"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "434ec0c7fe3742c984919a691b2018a6e9694425"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "d38bf781f16e180a1b2ad82697d2f81d7b7ecfac"
  end

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/kahing/goofys").install contents

    ENV["GOPATH"] = gopath

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/kahing/goofys" do
      commit = Utils.popen_read("git rev-parse HEAD").chomp
      system "go", "build", "-o", "goofys", "-ldflags",
             "-X main.Version=#{commit}"
      bin.install "goofys"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/goofys", "--version"
  end
end
