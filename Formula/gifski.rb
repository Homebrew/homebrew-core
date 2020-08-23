class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.0.tar.gz"
  sha256 "6571ad379a39604ecd7688f32841a8d76465af0f637cdcfe6d10b7ed8e6a3d6a"
  license "AGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "25e42fe5ad4a1c284eb10c752e9bdcf65e2bfdfee0b91550d01a6e48dd1714e9" => :catalina
    sha256 "9e802fa5a121cbcba1a8d7f9d8e3f76545b04a4fa530a519cf68b7742ad2d843" => :mojave
    sha256 "342d5512bf5f78a13a09a0237c18de0f18245b350a249e3f62072ab72baf26aa" => :high_sierra
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
