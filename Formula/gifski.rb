class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.2.tar.gz"
  sha256 "d7bf1b6515c273b822c94fc78e6d10fbc45d444a04bc3487fe3e799d6aa836e0"

  bottle do
    sha256 "48f7b226aad64ed09df2ba12aef1c5eb4d50bdd2892338205050a9508b4b441d" => :high_sierra
    sha256 "bd9d8fa459ecd0be1163d188f2dce0df132a2a6a1df11c718e74c746c8da34c0" => :sierra
    sha256 "8451f3f386963c5a48e48ae62028c8c954c9c91395ac2b47dcf51e87380b987b" => :el_capitan
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
