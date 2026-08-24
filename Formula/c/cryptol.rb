class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://galoisinc.github.io/cryptol/master/RefMan.html"
  url "https://hackage.haskell.org/package/cryptol-3.5.0/cryptol-3.5.0.tar.gz"
  sha256 "7341c026ef83b18d2c784cfedb37003f74d1560605cd9c3107b5b6fc31fb2f84"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "442c223f23feefe428c40453fec095caac6b0eae8fc6e757ce927df7a48b34b5"
    sha256 cellar: :any, arm64_sequoia: "5eedb6d9e418457f4a167256cb66e9af62e8615f6824e3727a7c7c6d3f283cdc"
    sha256 cellar: :any, arm64_sonoma:  "883d9fa8b52331e1f3d63afcbf445a85043dfe4e32f33f15eb633fea00bd4260"
    sha256 cellar: :any, sonoma:        "3e77ef0212f48a223ced63e75a1f40bf610607ad0b44615d1ba36a9d435dd89b"
    sha256 cellar: :any, arm64_linux:   "772daa96008c391f444a2b33c1a6b4ab219bffdf4b1932ac8c882eb3c0729ce9"
    sha256 cellar: :any, x86_64_linux:  "7a2376a36d364c39725f0a119a3c2ea4123fe5d4cf6b50fe15784fa1bd6021e6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.12" => :build
  depends_on "gmp"
  depends_on "z3"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
