require "language/go"

class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/da126a3959d3c1695b67d93a517a72617cc740c4.tar.gz"
  version "5"
  sha256 "821c08f8cbb27657e8cdeeab00ca9ec3123ae678479b4a3b3e028d0c540e4182"

  depends_on "go" => :build

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "9e777a8366cce605130a531d2cd6363d07ad7317"
  end

  go_resource "github.com/nsf/termbox-go" do
    url "https://github.com/nsf/termbox-go.git",
      :revision => "5c94acc5e6eb520f1bcd183974e01171cc4c23b3"
  end

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/gokcehan/lf"
    bin_path.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"
    cd bin_path do
      system "go", "build", "-o", bin/"lf", "."
    end
  end

  test do
    system "true"
  end
end
