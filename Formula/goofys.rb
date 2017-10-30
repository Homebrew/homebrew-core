require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag => "v0.0.18",
      :revision => "3de19ca7fb10649e74657965bdd7cacaf6b9f851"
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
        :revision => "1ab97fb2ebca4ac38b4e50291e28533b4b86e0cb"
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
        :revision => "298c54b0e0ae32ec2c6674fee8b60d2fefa4ae7e"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "48fc5612898a1213aa5d6a0fb2d4f7b968e898fb"
  end

  go_resource "github.com/sirupsen/logrus" do
    url "https://github.com/sirupsen/logrus.git",
        :revision => "89742aefa4b206dcf400792f3bd35b542998eb3b"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "7bc6a0acffa589f415f88aca16cc1de5ffd66f9c"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "2509b142fb2b797aa7587dad548f113b2c0f20ce"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "4b14673ba32bee7f5ac0f990a48f033919fd418b"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "176de7413414c01569163271c745672ff04a7267"
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
