require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.4.tar.gz"
  sha256 "42094336b769db7dbc731f0c146c606ee3f6435c038db53c9b67793edb3c5be0"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66b5289da092c27610df5c71e5aeb10de7582b079c543f4f807699ee5b9d1ac4" => :sierra
    sha256 "6383e6fd89bf87caaf1916d8389da43eead6cbb272f7e195de5bf6dd84db30db" => :el_capitan
    sha256 "3f12372641d47c4bf8239b69dd73bb9137101a68603551b2290a709ce86014a0" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "ad5389df28cdac544c99bd7b9161a0b5b6ca9d1b"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "fc9e8d8ef48496124e79ae0df75490096eccf6fe"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "8351a756f30f1297fe94bbf4b767ec589c6ea6d0"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "1cbadb444a806fd9430d14ad08967ed91da4fa0a"
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
