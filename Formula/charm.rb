require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/v2.4.0.tar.gz"
  sha256 "02f5b9c5211467353dbcf9589ecf70d6e7debf16e3a8b85fa870084525466731"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fceac06a83052ab1a67a5845ebc910438105e543677756c774c05b3a03a81c8" => :mojave
    sha256 "0b0552a903e6a0a29fbf38c1d2110263df22fd5a12599e36cd60b22bc1dab71e" => :high_sierra
    sha256 "1e3250586c714b629398dc02cd1b8168fe0cfe70a8a067d700b8b425f16d2ffa" => :sierra
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build

  go_resource "github.com/kisielk/gotool" do
    url "https://github.com/kisielk/gotool.git",
        :revision => "80517062f582ea3340cd4baf70e86d539ae7d84d"
  end

  go_resource "github.com/pelletier/go-toml" do
    url "https://github.com/pelletier/go-toml.git",
        :revision => "603baefff989777996bf283da430d693e78eba3a"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :revision => "fd2d2c45eb2dff7b87eab4303a1016b4dbf95e81"
  end

  go_resource "github.com/rogpeppe/godeps" do
    url "https://github.com/rogpeppe/godeps.git",
        :revision => "404a7e748cd352bb0d7449dedc645546eebbfc6e"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/juju/charmstore-client"
    dir.install buildpath.children - [buildpath/".brew_home"]
    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/rogpeppe/godeps") { system "go", "install" }

    cd dir do
      system "godeps", "-x", "-u", "dependencies.tsv"
      system "go", "build", "github.com/juju/charmstore-client/cmd/charm"
      bin.install "charm"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/charm"
  end
end
