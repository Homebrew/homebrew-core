require "language/go"

class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      :tag => "v0.0.10",
      :revision => "6b1426ffa4010f35997d943de13c7dd2d03cf217"

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
        :revision => "10f801ebc38b33738c9d17d50860f484a0988ff5"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
        :revision => "ab403a54a148f2d857920810291539e1f817ee7b"
  end

  go_resource "github.com/jacobsa/fuse" do
    url "https://github.com/jacobsa/fuse.git",
        :revision => "dc1be2d5b8abc34991a649f7499f9f673e36bb46"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "9d302b58e975387d0b4d9be876622c86cefe64be"
  end

  go_resource "github.com/sevlyar/go-daemon" do
    url "https://github.com/sevlyar/go-daemon.git",
        :revision => "8577c7ddef908e104dae56c9e46f0956cb33c844"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
        :revision => "119305b4ceb81cc9314ee187970584a0923b0679"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
        :revision => "0819898fb4973868bba6de59b6aaad75beea9a6a"
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
