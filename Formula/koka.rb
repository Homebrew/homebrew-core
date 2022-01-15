class Koka < Formula
  desc "Compiler for the Koka language"
  homepage "http://koka-lang.org"
  url "https://github.com/koka-lang/koka/releases/download/v2.3.8/koka-v2.3.9-source.tar.gz"
  sha256 "ae3e8127b46e51cc4df3525c5f913ecfbaeeb29f0a268e4a3d2e0ac809bc987f"
  license "Apache-2.0"
  head "https://github.com/koka-lang/koka.git", branch: "master"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "vcpkg"

  def install
    system "cabal", "new-update"
    system "cabal", "new-build", "-j"
    system "cabal", "new-run", "koka", "--",
           "-e", "util/bundle.kk", "--",
           "--prefix=bundle/local-brew", "--postfix=brew"
    share.install Dir["bundle/local-brew/share/*"]
    lib.install Dir["bundle/local-brew/lib/*"]
    bin.install Dir["bundle/local-brew/bin/*"]
  end

  test do
    (testpath/"hellobrew.kk").write('pub fun main() println("Hello Homebrew")')
    assert_match "Hello Homebrew", shell_output("#{bin}/koka -e hellobrew.kk")
    assert_match "420000", shell_output("#{bin}/koka -O2 -e samples/basic/rbtree")
  end
end
