class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.4.tar.gz"
  sha256 "8a968a8b9f605746dfeaf1083a0c6a2a3c68e7d8d62f43bb6a6cd58e9a3d260e"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    cellar :any
    sha256 "20e76add05177bebdbee36334ad956f521c1702f440e50c85b63d306f951575f" => :big_sur
    sha256 "528c768120c91ded3d7ffdcdd4b3bc4f4daf33e678e98ff123324312fff8e0db" => :arm64_big_sur
    sha256 "df5f0713070679c35ef4d96c04cfe41c814cd6b10193746376ca98af636b46fb" => :catalina
    sha256 "8b495ff4083d519ff85a62bf0a1f18bdc43f537575abc2709d6d873367bf4b1d" => :mojave
    sha256 "cf2bb34c28d2eb6e610e130798638dc68712cd6337520c409e950abc516f4f59" => :high_sierra
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
