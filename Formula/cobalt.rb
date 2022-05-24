class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.17.5.tar.gz"
  sha256 "17603490ba4817ec6ab3c486e39ac5863dd8625b58d8f8bfb534c83d7af334ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a30f9e2d852af5188fd2ca401d9fedc6e144cfd4396443e090f348d66c6fd046"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcb27c0f93d84fd91df1880b990170533a8465eb502a456395c4bdb2b234b1cf"
    sha256 cellar: :any_skip_relocation, monterey:       "0f3cef0a5fd121d1e201e2ea4ee5a1710b3dd74c9050206007813a0ffb86ad8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4faa2823f4e77bee6fd4eb0c33e812ac70ef146a08cee217ff6bee0187372e2b"
    sha256 cellar: :any_skip_relocation, catalina:       "b6ec26eb9641e547d6ab8ecd4bc22b75ffb9141b1bad4e14b5e4b8b161241744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "133bf757f77fd3bbfe47cacd434fd0faed6b1b15b123f60a7aa986fd8f9b5a3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
