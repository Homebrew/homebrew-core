class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/0.8.0.tar.gz"
  sha256 "f3cab822dd41de17ba4fdc3b8d379b469404573b1a4adcb5f9c9385a7a927760"

  bottle do
    sha256 "a6d535fc0ac55df2e143c1f27f0ae8411654142094e99b56d569a65dfb5b13ef" => :high_sierra
    sha256 "06399a4deeb177f4912d5def494e347857d7179410fb9b6c8cd6bd3bde4f60dd" => :sierra
    sha256 "164fe31349cf7f9415750b2db4e16e813fecb42a8e68b584884dfa11295b05c5" => :el_capitan
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
