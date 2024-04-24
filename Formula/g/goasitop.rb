class Goasitop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/context-labs/goasitop"
  url "https://github.com/context-labs/goasitop/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "a17fb6b7ba87cd055371aa82abef7388cb6e8114cad92479f82eb58f5d9c46dc"
  license "MIT"

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  # Restrict formula to macOS on Apple Silicon only

  def install
    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/goasitop", "--version"
  end
end
