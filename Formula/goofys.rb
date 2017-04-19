require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag => "v0.0.9",
      :revision => "f8d668c29bbf43aa36acea68e05b493f16f5e990"

  head "https://github.com/kahing/goofys.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "214c728ceb4cac8d251dbc45630093d00db03a2bf43d9d6cab5d5ed0bd880d64" => :sierra
    sha256 "f2a85e78185766488a036cb6fd2bf1a5523ad5d9acb3f5e6b1b6c9d78a8ead80" => :el_capitan
    sha256 "198a37cf47fe63c25f72ce0aa490fbc2efa4ffc0d9f0195d5334524ce2a26ff6" => :yosemite
  end

  depends_on "go" => :build
  depends_on :osxfuse

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
        :revision => "881bee4e20a5d11a6a88a5667c6f292072ac1963"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "0bdeddeeb0f650497d603c4ad7b20cfe685682f6"
  end

  go_resource "github.com/jacobsa/fuse" do
    url "https://github.com/jacobsa/fuse.git",
        :revision => "2642d571aa800c9ddca51e63800a57046970ce96"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "c2c54e542fb797ad986b31721e1baedf214ca413"
  end

  go_resource "github.com/sevlyar/go-daemon" do
    url "https://github.com/sevlyar/go-daemon.git",
        :revision => "8577c7ddef908e104dae56c9e46f0956cb33c844"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "93564b314264efac01934715fad4c355ed6af1c5"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
        :revision => "8fd7f25955530b92e73e9e1932a41b522b22ccd9"
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
