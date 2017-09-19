require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag => "v0.0.17",
      :revision => "3d40e98b163a797e800550a30e950dc06f7229b1"
  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c404ec2ec1fb719bf9ccddd33e870710c95c7d137fd150624ed9c4487e4e65a" => :high_sierra
    sha256 "0aadab7b39adbda711676f4f3da0fea7cf6d64e3d95e8386166df760904690c3" => :sierra
    sha256 "0d507abec9d46417d3f28ef78c7d8879b26e728026ae3ab7a39989d514a5dae0" => :el_capitan
    sha256 "786d318dba4292b4dbb3ebda22fbf96fab1dace9c71ed430a3e6939816088f74" => :yosemite
  end

  depends_on "go" => :build
  depends_on :osxfuse

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "f017f86fccc5a039a98f23311f34fdf78b014f78"
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
        :revision => "298c54b0e0ae32ec2c6674fee8b60d2fefa4ae7e"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "a452de7c734a0fa0f16d2e5725b0fa5934d9fbec"
  end

  go_resource "github.com/sirupsen/logrus" do
    url "https://github.com/sirupsen/logrus.git",
        :revision => "89742aefa4b206dcf400792f3bd35b542998eb3b"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "81e90905daefcd6fd217b62423c0908922eadb30"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "66aacef3dd8a676686c7ae3716979581e8b03c47"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "7ddbeae9ae08c6a06a59597f0c9edbc5ff2444ce"
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
