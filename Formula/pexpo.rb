require "formula"

class Pexpo < Formula
  homepage "https://github.com/nnao45/pexpo"
  url "https://github.com/nnao45/pexpo/archive/1.30.tar.gz"
  sha256 "c559a49925b46572718daf6894b2bf3383a703e1bc379851d40900fc84389e4c"
  head "https://github.com/nnao45/pexpo.git"
  version "1.30"

  depends_on "go" => :build
  depends_on :hg => :build
  
  def install
    ENV["GOPATH"] = buildpath
    
    # Install Go dependencies
    system "go", "get", "github.com/dariubs/percent"
    system "go", "get", "github.com/mattn/go-runewidth"
    system "go", "get", "github.com/nsf/termbox-go"
    system "go", "get", "github.com/tatsushid/go-fastping"
	  
    # Build and install termshare
    system "go", "build", "-o", "pexpo"
    bin.install "pexpo"
  end
end
