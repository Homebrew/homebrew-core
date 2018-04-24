require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.6.0.tar.gz"
  sha256 "9d74f885c70bad15034cafb7210a5b2e1be299a5e41387bb9550471e5c52e0ea"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "223a80c6991435500127b259cf0e6c64a1d71bca77246d882fa91493d7d08e12" => :high_sierra
    sha256 "d5f945e8236d9c8cd38f156b59f05d1583c1276cdfe2e7120dbd59d5a44d8e01" => :sierra
    sha256 "02de5967b589cf07ce7c3f19a5004055a136bcf38f286672270459d76da5fbfb" => :el_capitan
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
