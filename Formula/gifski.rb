class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.2.tar.gz"
  sha256 "e5830f18b38fb333f1d89af99d651c173c816d71f764e703460a38d241ce8df4"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    cellar :any
    sha256 "a182e69abac92bdf599cc3d3ebacb1ea35e927fd3e449b59998d91bdcd869a9b" => :catalina
    sha256 "e741a3a221748d34c244db43da3b8823087bb82bd5ab78e29914292f5a4120a1" => :mojave
    sha256 "b0de13b3b0b300bf7c6317db0bfcb619384ec0809ef4c75e984b457e2713db65" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", "--features=video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
