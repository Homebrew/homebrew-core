class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka/releases/download/v2.4.0/koka-v2.4.0-source.tar.gz"
  sha256 "3433ffe6b78d0bac9b25be2a1b3230610fb6e8b4a6a059d592278184f074ebb1"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b38553baeacde3c35f9f15a0e8b965a2339bb869005246a4fadc43f4f439fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28fdf434b85e0a870a4c95df37c01ceef08acfd24c3f46cc8b8d951302a979a3"
    sha256 cellar: :any_skip_relocation, monterey:       "68958c63842282b7563f6a63dbbae438f874b879df615e2d6d1d99af73e73eb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7db9cac9b21d7bed7ba1a53fcebe9d2bf7af40a7c1bb2976ba46cb6baa38d4a5"
    sha256 cellar: :any_skip_relocation, catalina:       "12926a0395ecf51ae86aca8a8eb385969a84403481e0186c60e19c5b7d75d240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "521c4355490fe35a17bc0892edb5045b13dc1c532533aa57bf391899bf248b34"
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
