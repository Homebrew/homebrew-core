class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-3.3.0/cryptol-3.3.0.tar.gz"
  sha256 "3ba3d1083c3aacd6c5ad5bbe4fddb9d9519717af4d3c6fe05d9c0c698fb737b0"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0b483d4d43bc85f9116569c83cfe63447e2cba780e009303cadc55466e0f8713"
    sha256 cellar: :any,                 arm64_sequoia: "f7b7abf27af0b5ca3f8b8d3fd5288e0ecb9c6afaaeb83bae498a598d4fc30bd8"
    sha256 cellar: :any,                 arm64_sonoma:  "a03b8f86803c0144c2cbdcb7d632cb0a3386fd489ecf213bd6d3b673b034554a"
    sha256 cellar: :any,                 arm64_ventura: "03e540dd50bd3460edb5ad7fb9f2177b4835b4f28be31b9c234bf81a270f6042"
    sha256 cellar: :any,                 sonoma:        "e25c25b3fef0ea6a40a48f8c91b8c85e51d047b7ab0a241a673ef87e8e8dce8c"
    sha256 cellar: :any,                 ventura:       "d2a976bb8d59a3420de74f51a86ea8334405959a719b17af0728320bae796518"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "553cf6f09cadf9872eb2c416530e93b543e10f0140f343754781e8dae33587a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810c037408fef1a2d44064270af18b78d964fc198b06898944ee0d7121cf38e3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "z3"

  uses_from_macos "libffi"
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
