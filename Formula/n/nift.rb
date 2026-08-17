class Nift < Formula
  desc "Fast dependency-aware website generator"
  homepage "https://nift.dev/"
  url "https://github.com/nift-dev/nift/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "0724c8e6518ea9ace4275e8f96da39680916d157df1afb4bfbb003678bcdfb52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51e849f54ad5792743c6b89a36f257d5fc947210b09ad314d8bad797e62033f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fec10d207430d130b05803646d881e52c0203d94a8a7918b0298727648889028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de007a3eacd4ea91f6f2b58328975048d230f035b097c605bbb2bc29036a734c"
    sha256 cellar: :any_skip_relocation, sonoma:        "26cae94de9efc67cabacec1fe1106592be97f0728b7116f15ab3df1cbca96865"
    sha256 cellar: :any,                 arm64_linux:   "952c4e873c95bbfeb746925eadcf02ff12e6b6489c46f552d579c408f14ed7a8"
    sha256 cellar: :any,                 x86_64_linux:  "808351e6bf7aaeabc2764af5b7154ed7dad3216f8d19c205589d8a42d4501927"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"nift", "init", ".html"
    assert_path_exists testpath/"public/index.html"
  end
end
  
