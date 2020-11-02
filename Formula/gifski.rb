class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.3.tar.gz"
  sha256 "52d87342125220a5d7552097adcfa43c12455709c32b4a52b27d56523a94de67"
  license "AGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "2ed67ec41d01f066787ae791cf9dae12a5fa789130191ff07df9fafc98fc533e" => :catalina
    sha256 "6d955ad92a79489e5d0ff927fc57c10a562efb1cb484fd85f7cf997b805184aa" => :mojave
    sha256 "515618c62c7f30df3913fa62c551193d973adfb8f0eb6c86d0acdcc8debd7c78" => :high_sierra
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
