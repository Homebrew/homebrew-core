require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/v2.3.0.tar.gz"
  sha256 "778d20848939a8162fa19acb5284b3c761047c3fa5ab49b36a83464eb4904261"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2d00519f4268e0a280c566a8c7f8802c9665fdcbc1a1cad601b764dc2a708d0" => :high_sierra
    sha256 "76bdfc5df35c1502e0f8453c5421c93e81477e081edb0b08cbfef96ea8ea2ae0" => :sierra
    sha256 "96b09b4ac7951ba465dc7322b680168c03828cb69443d84b5013df74ed7f4771" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build

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
