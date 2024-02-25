class Decanter < Formula
  desc "Autolab from the CLI; Decan't you see why that's awesome?"
  homepage "https://github.com/p5quared/decanter"
  version "0.2.6"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build"
  end

end

