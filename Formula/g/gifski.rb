class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.34.0.tar.gz"
  sha256 "c9711473615cb20d7754e8296621cdd95cc068cb04b640f391cd71f8787b692c"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e55280965509e5041e2c0efd99a25e9906ba43cbe6fa5200d0027c2dac18aff"
    sha256 cellar: :any,                 arm64_sequoia: "205522bc5cb89dfa53c681530244d9cae2433329d79b4c3b12bde6c7468d31d4"
    sha256 cellar: :any,                 arm64_sonoma:  "3109c7c055efa911b5ffe699510578b102f55039002c3a52123745c5ca05f49e"
    sha256 cellar: :any,                 arm64_ventura: "36f5c199f5588451d45a52bb5f34b1b35aedcf1c0f6c60851b43baeb6334a89b"
    sha256 cellar: :any,                 sonoma:        "22cfac392e6a29240f4b625d78b74d6419632e2db533f9ecf9734eb8a8a304c0"
    sha256 cellar: :any,                 ventura:       "3455fccb41835e209d257d88b6cea7343788b8b6495644949f5e04eeca6f9ccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dac8a71c3bfd0ec989c33504a358645d7c35819b1f6c2718cdd58eefc5f8f987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "896256805d8414a21e0c2f5fe2e40a543a840d9cbb017b8288304d5f7d8e70a7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@6"

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_path_exists testpath/"out.gif"
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
