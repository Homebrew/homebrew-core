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
    sha256 "ddafa269456b20fa12bab697cb54dab3590e8c37668e96d26dacffbd0f5d98c3" => :sierra
    sha256 "5be7566385a86b295d121e721e3f2e6e9629d44e4a404f3a968dbe46553ee59f" => :el_capitan
    sha256 "6680d49d0784ecba64ab26daf251651cc8548611bdbeedd6bd5b80e9cf82cd56" => :yosemite
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
    end
  end

  test do
    system "#{bin}/goofys", "--version"
  end
end
