class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "0724c8e6518ea9ace4275e8f96da39680916d157df1afb4bfbb003678bcdfb52"
  license "MIT"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", ".html"
    assert_path_exists testpath/"public/index.html"
  end
end
  
