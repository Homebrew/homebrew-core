require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.2.tar.gz"
  sha256 "de1c4361223f65617f56e08ac900de40a7f0c14c13d3cdcf4590e669079f81ad"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f9f790dcd00a2e8919d6d79bcf610d1886b65fda98f11e0c721ad055d97b97a" => :sierra
    sha256 "ec1549f0b6a1a03ead19d01d6ae0a0b18d9bcf125b15b47c08611bdb137932f2" => :el_capitan
    sha256 "a03ab49f750e73bfdc7bd4aec1f39fc9ce2d0255d05dbc6851046ca4b6e5401a" => :yosemite
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
