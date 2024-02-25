class Decanter < Formula
  desc "Autolab from the CLI; Decan't you see why that's awesome?"
  homepage "https://github.com/p5quared/decanter"
  url "https://github.com/p5quared/decanter/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "c23306d2aa65d7ec740500e2a387079888f067ef5518807dc4a06ae2696aa333"
  license "MIT"

  depends_on "go" => :build
  def install
    system "go", "build"
  end
end
