require "language/go"

class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v1.4.2.tar.gz"
  sha256 "e90990f45f06324eb2378369b795a526a6145ca12c8a631493505f1ecfada74f"
  head "https://github.com/OJ/gobuster.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b9242b221840de7f36b70fc1942d939b107cf753df7ec38bff59610e5708055" => :high_sierra
    sha256 "45026bb16e7cb74a0e01779d5215e62b96f3cde44c5af879786acca524a3fa42" => :sierra
    sha256 "3f76c44c22a2d08796db6e2b371df9065e67276bc32a8494cce5d34367230da3" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
        :revision => "b7773ae218740a7be65057fc60b366a49b538a44"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
        :revision => "36e9d2ebbde5e3f13ab2e25625fd453271d6522e"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "a49355c7e3f8fe157a85be2f77e6e269a0f89602"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "1b2967e3c290b7c545b3db0deeda16e9be4f98a2"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/OJ").mkpath
    ln_sf buildpath, buildpath/"src/github.com/OJ/gobuster"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"gobuster"
  end

  test do
    assert_match(/\[!\] WordList \(-w\): Must be specified/, shell_output("#{bin}/gobuster -q"))
  end
end
