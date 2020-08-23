class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/v0.5.8.tar.gz"
  sha256 "90d87503265c12f8583f5c6bc19c83eba7a2e15219a6339d5041628aa48c4705"
  license "MIT"
  head "https://github.com/peco/peco.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02aee47d2d6e04c17c5a8a0c0d4391004175b00d2c01550b37bec09be865953a" => :catalina
    sha256 "f2c6e54d44a476bdfcab73c53789fceceeda94101e1b537525af870b1995a5aa" => :mojave
    sha256 "fb083704e02c7b00b740039da5a93c505ac4448b3e568fc04756902c28d68202" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    system "go", "build", *std_go_args, "cmd/peco/peco.go"
  end

  test do
    system "#{bin}/peco", "--version"
  end
end
