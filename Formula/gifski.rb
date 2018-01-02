class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.7.1.tar.gz"
  sha256 "c67bbecd7802c0b91e5177edcc39b3492e9fcbd1eee4392c044697bc0f78a409"

  bottle do
    sha256 "fb398e629ed6b5ef9886afc8236feef28a570f7992c4b5c74450c9c3e7b2619a" => :high_sierra
    sha256 "cffcecbedd1bbb7e88e4165dca530dfc57f50a9e4dc1a5e72bef4620bf62ed91" => :sierra
    sha256 "bf04318ee03ef9b487a1ad5047fbeaa3af411685e3e12884b5a6712c47d27cbd" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "build", "--release", "--features=video"
    bin.install "target/release/gifski"
  end

  test do
    system bin/"gifski", "-o", "out.gif", test_fixtures("test.png")
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
