require "language/go"

class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.3.6.tar.gz"
  sha256 "edc1ec186a0f439ae84071c9e00f68fec6f8fe49efc9b6bb10462e72f7286b23"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8c03e514e10c5d2c6824838a9d8777624f2295ac9d8fc7cca92a5298dcb0b22" => :el_capitan
    sha256 "5b8320b037471270db0c9c1a866c15d00225a2b1b147b74e4bdbb3e696e136db" => :yosemite
    sha256 "ca37bbcdaee4c45e850872b7835128e8ca1e675684e8e5e17d48b790cddca1d0" => :mavericks
  end

  head do
    url "https://github.com/peco/peco.git"

    go_resource "github.com/lestrrat/go-pdebug" do
      url "https://github.com/lestrrat/go-pdebug.git",
      :revision => "a45b04725d5819f9f30fb68085be53b90a1d55f1"
    end

    go_resource "github.com/pkg/errors" do
      url "https://github.com/pkg/errors.git",
      :revision => "01fa4104b9c248c8945d14d9f128454d5b28d595"
    end

    go_resource "golang.org/x/net" do
      url "https://go.googlesource.com/net.git",
      :revision => "ef2e00e88c5e0a3569f0bb9df697e9cbc6215fea"
    end
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
