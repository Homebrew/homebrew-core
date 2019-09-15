class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.9.1.tar.gz"
  sha256 "f39a6e510e825bf4b43aebd1d7fb581d3b59a11bf7521bf6f507d4b0fa684b76"

  bottle do
    cellar :any_skip_relocation
    sha256 "c259af696f34802bde2f7376506cf2b2ff1f0ed8781cd8f9b723c2066324c8da" => :mojave
    sha256 "d4bc8326504cf4703b7bc548c3534cac6e3f2d8741f8f9c6355206522984b8f7" => :high_sierra
    sha256 "7dd6250d1cbb19abd7b281f345979ead819f7db5f208cdb2ef70254c2cc9445e" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
