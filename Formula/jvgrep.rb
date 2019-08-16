require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.8.0.tar.gz"
  sha256 "5a31dbe457ba5ed8492a0ac59eecb22356754f456086ee4e95f296fc6f4bc8c8"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b8f71a3d59dab1504e2669a521c915db536a1abad78376e6117db3cd1cfd9bb" => :mojave
    sha256 "8c4d2303e126c9ced3ebc2d66534f23739b88bef019540d502146d1f62d62ebe" => :high_sierra
    sha256 "c550ceee87b9c7139b966ae4879ea5e1e3996b86410b2456619b667d7052830e" => :sierra
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "efa589957cd060542a26d2dd7832fd6a6c6c3ade"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "6ca4dbf54d38eea1a992b3c722a76a5d1c4cb25c"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "5f9ae10d9af5b1c89ae6904293b14b064d4ada23"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "7922cc490dd5a7dbaa7fd5d6196b49db59ac042f"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/mattn"
    ln_s buildpath, buildpath/"src/github.com/mattn/jvgrep"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"jvgrep"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
