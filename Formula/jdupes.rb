class Jdupes < Formula
  desc "Duplicate file finder and an enhanced fork of 'fdupes'"
  homepage "https://github.com/jbruchon/jdupes"
  url "https://github.com/jbruchon/jdupes/archive/v1.21.2.tar.gz"
  sha256 "5c92333b06cefb1092bf398349218499c6aba94ae735316623a0114f9eda0f75"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9595418b022ed126935f16404e6e2503fc92a8d6f5c017bbe1748636cf86ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa5affbd9d962355b5128e1e73927cf9fe2c6720cf05cba8ec48104bd80f1e5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb66eb36d818d088754b3dac1469f10edcc8aa2fb7db656956ada41fcab5ce6a"
    sha256 cellar: :any_skip_relocation, ventura:        "56e94b0a68d4b53e85eb60ce7d3e1f82c20c31b77563a09fe5dfee44f44b2c86"
    sha256 cellar: :any_skip_relocation, monterey:       "4f98e32a7c47f67b52de7a1ac1e16810fd94e410c3e064310604f50381251fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d94e1e28842622a85ec6295da35c901f4e724ddb74429910cfced64fd111aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50cc4992d4da919e76961619f845b5bc8e4ad11e9487d9883ae2d65a2a0d4e35"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ENABLE_DEDUPE=1"
  end

  test do
    touch "a"
    touch "b"
    (testpath/"c").write("unique file")
    dupes = shell_output("#{bin}/jdupes --zeromatch .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
