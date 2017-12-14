class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.7.0.tar.gz"
  sha256 "d555aa2e89eca058cfa23aa2dee6285b2e0e20590313f8e1fe26fcf8ed5dd0df"

  bottle do
    sha256 "eba01b60ef395ec9015c583e4f88192a289c2e65d95b1d8bf5313f8a920c303d" => :high_sierra
    sha256 "283fcc59f76a59bfa9020cb00ab545df478f9176816fcd1656fa7ee65c1ed416" => :sierra
    sha256 "164c0b92ecd419287436a11986214015e2bd19c330080fd4e4e4b43922fe5756" => :el_capitan
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
