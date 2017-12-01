require "formula"

class Pexpo < Formula
  homepage "https://github.com/nnao45/pexpo"
  url "https://github.com/nnao45/pexpo/archive/1.32.tar.gz"
  sha256 "764f08c054d8c2b8f5b0f895917afb018b640b70cce6210a1141e998843548fd"
  head "https://github.com/nnao45/pexpo.git"
  version "1.32"

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
