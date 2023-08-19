class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka.git",
    tag:      "v2.4.2",
    revision: "0649baaa2a4509c0a5adb743b6f2b5f1ef32a5a9"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c7bb3e634d9f70707fb4aebdebbff608eb3513fef7d0bdc8a35c401ab4fe998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2ae24999dbb1f786121955d30e09cb00ea6db02b8622fb7de05f373e2220b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48d6175b97469e402e45f3918cc2d05affabe9e153447e26f56f0ec53c2d69d8"
    sha256 cellar: :any_skip_relocation, ventura:        "c69c09e84deb27f8b32163131918714535c6810f1d873d6793fa7b86178986cb"
    sha256 cellar: :any_skip_relocation, monterey:       "0670c1d6a4f5fbdddc5341288d4cd1cfc10fea15c4f28f6268b0d08c597e4cc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ef28648db9b810680a493a7e881f062008c6c6293c75d370c0c77b593daaf26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7544dd6e98024c7e4f2dba7a293c81be0ce090bba732bba6b4cc198de71cf6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pcre2" => :build

  def install
    system "cabal", "update"
    system "cabal", "build", "-j"
    system "cabal", "run", "koka", "--",
           "-e", "util/bundle.kk", "--",
           "--prefix=#{prefix}", "--install"
  end

  test do
    (testpath/"hellobrew.kk").write('pub fun main() println("Hello Homebrew")')
    assert_match "Hello Homebrew", shell_output("#{bin}/koka -e hellobrew.kk")
    assert_match "420000", shell_output("#{bin}/koka -O2 -e samples/basic/rbtree")
  end
end
