class Gif2png < Formula
  desc "Convert GIFs to PNGs"
  homepage "http://www.catb.org/~esr/gif2png/"
  url "https://gitlab.com/esr/gif2png/-/archive/3.0.5/gif2png-3.0.5.tar.bz2"
  sha256 "8cc0733ad5d48329da903d1a56e01adbaa4994181f5a12ce962fd4f2c504da22"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/gif2png.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9072daea5a28d0eba5c9a9a257d3b6c4db506850664c984c99b00ec9a3468261"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6eb0df92c042ea7374914ce882ec21d65472a09f5013630b36a241078d60b72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc0ce2b2d0addfdc44382ebceee4e6d52f7918aefd122df5f87f9a71baa21f7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "714585f82948199d3472d006df236b34a414a7b619e063d4b1a777a4d3d60e78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51af9f96e11fc6491de11c5cae014166ef7f09d7a27262b23bfdd55245f52c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d61538f849b6acd24ee452098e64e9f293587237b032d0466a8d37f3315981c6"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build

  uses_from_macos "python" # for web2png

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.gif"), testpath/"test.gif"
    system bin/"gif2png", "test.gif"
    assert_path_exists testpath/"test.png"
  end
end
