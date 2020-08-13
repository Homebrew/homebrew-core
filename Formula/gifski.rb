class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.0.tar.gz"
  sha256 "6571ad379a39604ecd7688f32841a8d76465af0f637cdcfe6d10b7ed8e6a3d6a"
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
