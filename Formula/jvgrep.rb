require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.0.tar.gz"
  sha256 "70078c61ff86a7d1c8c689c8535d06010672027d636f6e624598ec186df4d2e7"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38b8af1c640f79662ba97801152bae1c679ca00a10ba85ceeffa8159092fb599" => :el_capitan
    sha256 "fc31de0cdd576b9abe3862568dcc1e972eb4799c955e3e85b9fa91c2dbdd72a2" => :yosemite
    sha256 "916da6aa146d12db9c414c9ff2520f852b89a1ac91d631530cd546e1ccc0c860" => :mavericks
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
