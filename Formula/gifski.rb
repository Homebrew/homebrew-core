class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.7.3.tar.gz"
  sha256 "0db038fa91764295b0caf473bfc09e577b926260f5f116687600ae7140811721"

  bottle do
    sha256 "cb2cb660f3f081945d28e359a2ed12b935ff6cf8bc95f535f2e5413cb1567174" => :high_sierra
    sha256 "9946cabfbc933615bc5129cf4b9bb9cedabf4b25762224a974bc2b221464d5d0" => :sierra
    sha256 "68964d76f8a2e59ca0a2379db20b6ab38bc127293e2369bedb4e1279541087da" => :el_capitan
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
