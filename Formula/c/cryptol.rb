class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  url "https://hackage.haskell.org/package/cryptol-3.3.0/cryptol-3.3.0.tar.gz"
  sha256 "3ba3d1083c3aacd6c5ad5bbe4fddb9d9519717af4d3c6fe05d9c0c698fb737b0"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "036f1699ef23e07d214b12ecd13e2a3f874e8546150628e03ab09d1cc4cdecfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d817b9266776e61b772285651066d2ac1d4c7184b7361abce9a383eeaa7bb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9035c6aa3b4bbc1e9f9731f92db90843d1e74dbb59d99930c737cc8510dccf59"
    sha256 cellar: :any_skip_relocation, sonoma:        "f26c5cc0f8e1d29455ffdf7d0875a1014b8b08929c62cbf6979e54eb24d1f816"
    sha256 cellar: :any_skip_relocation, ventura:       "9d37ae517d04c7def64d26f0451d8ac964c41e7d025dc204a01c68069920b386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab55afae719399479d3b8f9ca9499f9fa7d26a5c8e5c985484d287d9234165b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d20522798fa5c6f11bc1bfab9506e4805bcc6b0eb675ccdc6e310c975809257"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build
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
