class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.4/purescript-0.14.4.tar.gz"
  sha256 "730b0ef2d479c1655f4ed7b1515629fd76bfbad57563779bf45e6ce63d48aa61"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e731bf3b7ccedffc2140340df285432f592e362c92a16108e991fa34066a274c"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd63479d4e3c3840de1d4570144323cf0c855fa04320115b48baa80f34e3a7a4"
    sha256 cellar: :any_skip_relocation, catalina:      "24592ee5e641295e60751043239c94c29e83be369157101f8a6532621928d5ab"
    sha256 cellar: :any_skip_relocation, mojave:        "d3206d2e8a4b865d7fa7a023d1f8e0dc2ae2f37a10aaf30ab9396c7860b280d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9af6b9149952cb98e0fcf394b5d8f5a7e4c1608f0d59b2065bd1b73cedf95e83"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.4.0.0/purescript-cst-0.4.0.0.tar.gz"
    sha256 "0f592230f528ce471a3d3ce44d85f4b96f2a08f5d6483edfe569679a322d6e64"
  end

  def install
    (buildpath/"lib"/"purescript-cst").install resource("purescript-cst")
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
