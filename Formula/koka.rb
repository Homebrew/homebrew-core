class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka/releases/download/v2.4.0/koka-v2.4.0-source.tar.gz"
  sha256 "3433ffe6b78d0bac9b25be2a1b3230610fb6e8b4a6a059d592278184f074ebb1"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "master"

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
