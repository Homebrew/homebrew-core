require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.2.tar.gz"
  sha256 "de1c4361223f65617f56e08ac900de40a7f0c14c13d3cdcf4590e669079f81ad"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "25875f8f7664bb73f67622364d5dbb4026dff1025bf21ca17237df834de75254" => :sierra
    sha256 "81f82bd8539e7f0b2a31e9c9762b2961ec914a0526e4f54fa96a870ff7afe64d" => :el_capitan
    sha256 "f2fbc679edd166fa0d8234ace76b4f57a597be97ff95260ae92cd2a3c85651ac" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "ded68f7a9561c023e790de24279db7ebf473ea80"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "fc9e8d8ef48496124e79ae0df75490096eccf6fe"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "59a0b19b5533c7977ddeb86b017bf507ed407b12"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "ccbd3f7822129ff389f8ca4858a9b9d4d910531c"
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
