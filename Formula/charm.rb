require "language/go"

class Charm < Formula
  desc "Tool for managing Juju Charms"
  homepage "https://github.com/juju/charmstore-client"
  url "https://github.com/juju/charmstore-client/archive/2.2.3.tar.gz"
  sha256 "1b6342577fbdebadc01e3b63739fb4c55dcf3321740119486d4886ba308963f2"

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
        :revision => "d6ce6262d87e3a4e153e86023ff56ae771554a41"
  end

  go_resource "github.com/rogpeppe/godeps" do
    url "https://github.com/rogpeppe/godeps.git",
        :revision => "e444a191d9b826975e788bb3c95511447393706d"
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
