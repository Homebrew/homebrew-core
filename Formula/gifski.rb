class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.6.2.tar.gz"
  sha256 "4f0379aa05a5e99fd6a9efb851efa7553e9663ec800ac7247fb7e26505a4b225"

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
