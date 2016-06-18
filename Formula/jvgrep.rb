require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v4.9.tar.gz"
  sha256 "74fe0090eb131ca5b8962886122606c7a5a8540e7992c71d138403731b704b4f"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38b8af1c640f79662ba97801152bae1c679ca00a10ba85ceeffa8159092fb599" => :el_capitan
    sha256 "fc31de0cdd576b9abe3862568dcc1e972eb4799c955e3e85b9fa91c2dbdd72a2" => :yosemite
    sha256 "916da6aa146d12db9c414c9ff2520f852b89a1ac91d631530cd546e1ccc0c860" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
    :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
    :revision => "9056b7a9f2d1f2d96498d6d146acd1f9d5ed3d59"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "1961d9def2b2d7a28d7958926d2457d05a178ecd"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
    :revision => "e3c902a8b2c4c420ce61514795e05b8e28a6364e"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/mattn"
    ln_s buildpath, buildpath/"src/github.com/mattn/jvgrep"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"jvgrep", "jvgrep.go"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"jvgrep", "Hello World!", testpath
  end
end
