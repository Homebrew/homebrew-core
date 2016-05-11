require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.6.tar.gz"
  sha256 "edc1ec186a0f439ae84071c9e00f68fec6f8fe49efc9b6bb10462e72f7286b23"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f42983ae2cdb2f8f4c583becbad5c708b95a9e9fbf474d80ee2abf813e16cd7" => :el_capitan
    sha256 "f327e9d88ef8f10a405b6296868b5782743d047b4b8df7b25647ad0b92c07062" => :yosemite
    sha256 "f341d17b7831b69486f632ed0b762610d47de56d364d4cf31e69ef49c67cc9ca" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/google/btree" do
    url "https://github.com/google/btree.git",
    :revision => "00edb8c3163323f673bbe3c04afd9429eb12117d"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
    :revision => "6b9493b3cb60367edd942144879646604089e3f7"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
    :revision => "d6bea18f789704b5f83375793155289da36a3c7f"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
    :revision => "362329b0aa6447eadd52edd8d660ec1dff470295"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/peco"
    ln_s buildpath, buildpath/"src/github.com/peco/peco"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "cmd/peco/peco.go"
    bin.install "peco"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
