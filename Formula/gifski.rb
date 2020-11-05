class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.3.tar.gz"
  sha256 "52d87342125220a5d7552097adcfa43c12455709c32b4a52b27d56523a94de67"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    cellar :any
    sha256 "026cb7b5320eac2dba06134f989ab3a2ca0e59c05233b9105125a7b4958627df" => :catalina
    sha256 "e499b92025e2a91e0d3baa2b53593f1a9be2e5f09bc7b1b1f94185b6368f9a45" => :mojave
    sha256 "1555dabc41a4d93e37b1b8343d55f4b42c4c72f98e79812fa99a05f86dae3cbc" => :high_sierra
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
