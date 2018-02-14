require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.5.tar.gz"
  sha256 "219cfa8be844542846538813b842f1f57c37eb9f2f6e3b63af32506aaba8da30"
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
