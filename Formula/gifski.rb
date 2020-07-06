class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.10.4.tar.gz"
  sha256 "0fd4b6beb880bb7719a3fb707f8f42678a62c8cf9bbb90f369f043864bbcc5ed"
  license "AGPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e00f209f81a6ae5e7b5f75427480776298d8cf4f9d8b5261e7c1a38e19858076" => :catalina
    sha256 "a654fc60bf8ff9e29499f3514c4ab85227886380cd9126591cfd1c1afb137dfa" => :mojave
    sha256 "a9e6089442617d5df7aa8b6e0baf11e5a5152adff89bb3d6cb018b61a8e3d387" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
