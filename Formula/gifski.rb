class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.2.6.tar.gz"
  sha256 "60af3329dfb8e86626e3251f57e13b4cfc0db79c4324ffbdbae3a9d7462cd1ed"
  license "AGPL-3.0-only"

  bottle do
    cellar :any
    sha256 "b0269f2aa746e8a4dcdeb5f27a7b91c0e894d73c2b5d8b3a4df1b1bf8aaa115f" => :big_sur
    sha256 "5a4a8e2702fda194cfb372519d7740f2d82ccb5c1d165672210ed2c21fbeef80" => :arm64_big_sur
    sha256 "ac9547281d15c75a5725aa21fa3d8b974c7b8b08e580d00c72e5d8058d1b696d" => :catalina
    sha256 "e06d9be5f774a40f746b99046ac7e7c8c517c9a84a9b15ca2b1231fbe6287e09" => :mojave
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
