require "language/go"

class Jvgrep < Formula
  desc "Grep for Japanese users of Vim"
  homepage "https://github.com/mattn/jvgrep"
  url "https://github.com/mattn/jvgrep/archive/v5.3.tar.gz"
  sha256 "c4724296d35c13d950a7632ccd8d6c7583a38d98cdf2da6203a413175c044712"
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
