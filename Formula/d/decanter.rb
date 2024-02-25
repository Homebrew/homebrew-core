class Decanter < Formula
  desc "Autolab from the CLI; Decan't you see why that's awesome?"
  homepage "https://github.com/p5quared/decanter"
  url "https://github.com/p5quared/decanter/archive/refs/tags/v0.2.6.tar.gz"
  version "0.2.6"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build"
  end

end

