require "language/go"

class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.13.1.tar.gz"
  sha256 "6fd7d3f7947437ba513654cf893c06a761321dd6fbe53ab56a3d1ca2e30bd060"

  bottle do
    cellar :any_skip_relocation
    sha256 "99001d66871f738fb68b5bc7514bf7a8ee759516cc0cbec6d47f0dbb5e3196b6" => :el_capitan
    sha256 "d94a1a91d61bcb9a9c4c2d3696eeb1fb5b51993c96d9c2c8bd83913e901fc441" => :yosemite
    sha256 "2fe7be530f9f863f0be4be8204b1b299e68c1bad105bd353d2bff0a05f8d503a" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/docopt/docopt-go" do
    url "https://github.com/docopt/docopt-go.git",
      :revision => "854c423c810880e30b9fecdabb12d54f4a92f9bb"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "f7445b17d61953e333441674c2d11e91ae4559d3"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
      :revision => "eca94c41d994ae2215d455ce578ae6e2dc6ee516"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "#{buildpath}/client/Godeps/_workspace/src/github.com/deis"
    ln_s buildpath, "#{buildpath}/client/Godeps/_workspace/src/github.com/deis/deis"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "client" do
      system "godep", "go", "build", "-a", "-ldflags", "-s", "-o", "dist/deis"
      bin.install "dist/deis"
    end
  end

  test do
    system "#{bin}/deis", "logout"
  end
end
