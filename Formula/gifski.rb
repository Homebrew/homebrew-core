class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.6.tar.gz"
  sha256 "60af3329dfb8e86626e3251f57e13b4cfc0db79c4324ffbdbae3a9d7462cd1ed"
  license "AGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "e28252b1eca7477fb8bf612345cb89436a76d2ba5d559fc5a9cc11ca66a4c1fc" => :big_sur
    sha256 "8ff94a08d8988c62f9ef1991324d0205b29fd128890746555a546f31c1272b9b" => :arm64_big_sur
    sha256 "38deabd72c6a81faf79f9441623eb06a80fb45d468ff5e64976915416cf60231" => :catalina
    sha256 "a7f1fe0ecc811745025d5da4ead971f292f40e9f097c4195cc9c24b24778fc84" => :mojave
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
