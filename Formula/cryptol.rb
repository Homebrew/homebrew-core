class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-2.12.0/cryptol-2.12.0.tar.gz"
  sha256 "1746b1ca1fa27d127bbb9f3a50956f1c04e99d2b42a1ddb0347d40dc4d5b058e"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "91082565f7096f7eac147693c74f80ec9f661a67bfef7a07c9361c82b32596df"
    sha256 cellar: :any_skip_relocation, big_sur:      "035bb1a575c63a3992a28e2f9adbcbf452ed423704089da835bc4f2b4241eba7"
    sha256 cellar: :any_skip_relocation, catalina:     "fc1c9ccb7aa2fa185a319e1bcf0de1bd7d45cf3a90234b50cb04c1db0f25aec0"
    sha256 cellar: :any_skip_relocation, mojave:       "472d4f5548696c9b0e7c3d512e6630111d7db23f0e37ac21d6193192eda135c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2ccacef5fd7f740050414d006cd5f3d3719b74c434fdd6fceadea501168b5412"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
