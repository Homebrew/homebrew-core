require "language/go"

class Gobuster < Formula
  desc "Directory/file & DNS busting tool written in Go"
  homepage "https://github.com/OJ/gobuster"
  url "https://github.com/OJ/gobuster/archive/v1.4.tar.gz"
  sha256 "e0469df94baf7f89c87e32d5fb4fa44cadaa30587ea843d2dbbe1792992ca143"
  head "https://github.com/OJ/gobuster.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1270beae977e7d29193fa09e684188a1122cc1ccea46419a2035c53ebd0d8ee" => :high_sierra
    sha256 "7da053cb4f0a73f55dc0cfaeea6628422e214e29c76a3f82c6ebe58faa2fe659" => :sierra
    sha256 "2499eb9e86e59b87640cc93fe8270be64cb1b5ce2a7e5a8d5a0bdcf69e68f054" => :el_capitan
    sha256 "4d781dd4d6bf9b3217d5d197b987583392ba8b6a4abc539720360041779889aa" => :yosemite
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
        :revision => "13931e22f9e72ea58bb73048bc752b48c6d4d4ac"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "810d7000345868fc619eb81f46307107118f4ae1"
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
