class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.15.2/purescript-0.15.2.tar.gz"
  sha256 "a4d99367b98dcc25f22721b633ca2a9d339131776f8e827b35a9738b7a3cd587"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fe8d1bf67e57ea71e9705133a81fc8049afde853851e5e6b2430ecdc52912f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58dba09950216eb6f4744ee23a912e36ef7ac743b1e83ad61129720f7f08d6d7"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7e059e82292c88aa9e421568064774eefd438d5b367a124ed63665abc0828f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4af8f1a20e9b64fdfa7d5e0d5c1af8e103eb8ef1283e0b302f6d26ac77b3a6e"
    sha256 cellar: :any_skip_relocation, catalina:       "96af01bf943909da52e71dc078a43ac3fb1719ca9e1694e094656e5e412abbd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f584e623814752682ba13e890c99af7f1012d1f990bedd085275859d2e5f4fc2"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
