class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.9",
      revision: "6bc498e625e66e3d0c947639dbffb09d986318d0"
  license "MIT"
  head "https://github.com/zyedidia/micro.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9698612758eab11ab60d57065d9314f5560f38de95308033758d671b2f39e52d"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d494288ce3dda95db3d44139de755a1d7436bfa41c848a5d6f8302107c3874c"
    sha256 cellar: :any_skip_relocation, catalina:      "bdc49d5bc540b16e9165eadb793fcf755a4342f1b53fb9df9d5859b51a8335c9"
    sha256 cellar: :any_skip_relocation, mojave:        "16194e8139cf062a789f767e4d9e572a31b5438c7abf36ee2615093de956d5a8"
    sha256 cellar: :any_skip_relocation, high_sierra:   "5ddc2cdc29a432a2515950946076ebb1ddf7dba410019fd77790f3ba5a2d874c"
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
