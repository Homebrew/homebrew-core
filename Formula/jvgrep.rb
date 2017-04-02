require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.1.tar.gz"
  sha256 "4fe6d3fa77c4e4c7860286435750d007b797604a661b324f2ae87d68fc34566a"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f9f790dcd00a2e8919d6d79bcf610d1886b65fda98f11e0c721ad055d97b97a" => :sierra
    sha256 "ec1549f0b6a1a03ead19d01d6ae0a0b18d9bcf125b15b47c08611bdb137932f2" => :el_capitan
    sha256 "a03ab49f750e73bfdc7bd4aec1f39fc9ce2d0255d05dbc6851046ca4b6e5401a" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/k-takata/go-iscygpty" do
    url "https://github.com/k-takata/go-iscygpty.git",
        :revision => "ef1d38de59ba64389903f1b91b99dfb80a4eda24"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "d228849504861217f796da67fae4f6e347643f15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "30a891c33c7cde7b02a981314b4228ec99380cca"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "236b8f043b920452504e263bc21d354427127473"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "dafb3384ad25363d928a9e97ce4ad3a2f0667e34"
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
