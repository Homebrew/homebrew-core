require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.0.tar.gz"
  sha256 "70078c61ff86a7d1c8c689c8535d06010672027d636f6e624598ec186df4d2e7"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45d5106b0e3a254203d40489bdfc6fd50fd44495aca304b61e691f79cb8d7def" => :el_capitan
    sha256 "c79c76dfa09b772150c27124f16dd173a96662dbfe5adcdba252a3f904e814b0" => :yosemite
    sha256 "4310042fda0b82082f52cd90572981e975e14693893f83c5382a352755d0dbbc" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/k-takata/go-iscygpty" do
    url "https://github.com/k-takata/go-iscygpty.git",
        :revision => "f91f8810106213f01bd64933dc10d849bd9137ac"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "9056b7a9f2d1f2d96498d6d146acd1f9d5ed3d59"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "e445b19913b9d40fdbdfe19ac5e3d314aafd6f63"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "4440cd4f4c2ea31e1872e00de675a86d0c19006c"
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
