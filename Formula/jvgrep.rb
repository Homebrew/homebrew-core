require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.5.tar.gz"
  sha256 "219cfa8be844542846538813b842f1f57c37eb9f2f6e3b63af32506aaba8da30"
  head "https://github.com/mattn/jvgrep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63c6e04a64fbeca0dc6d6a3089f9ee5a508ac868d7ec491160a73c4e093b4652" => :high_sierra
    sha256 "542343fb7812777bfe00c0199bf6c7810276d6826e4b2bb7ebf0adcf85d01400" => :sierra
    sha256 "c1f8cac9998ec76a48434cabc029f413145c5b97669bbea8a344f52d27388f6a" => :el_capitan
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
