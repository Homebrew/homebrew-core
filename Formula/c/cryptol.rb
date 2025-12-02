class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://galoisinc.github.io/cryptol/master/RefMan.html"
  url "https://hackage.haskell.org/package/cryptol-3.4.0/cryptol-3.4.0.tar.gz"
  sha256 "5973570dfd307c0a27251bb8edcfd554034549b21dfba7b69f21963d3361a388"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07bac4c0cbc02e26d1dd4b2604a3f2904f340b022b1ad812af3af37de9d640ee"
    sha256 cellar: :any,                 arm64_sequoia: "b6e78da5494caa934c0e80fdb21d6981935406e912b4568aa97f5ee132f561df"
    sha256 cellar: :any,                 arm64_sonoma:  "9bea8476f6309d861c0b1d224f49e20ce28d7dc2d159f7926f48fd90126aae74"
    sha256 cellar: :any,                 sonoma:        "fc050c33e3790a174136ccdbbb943afaa4034b947f38e1062590f660d4c81ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d95ecef567af42b2ba1fde9260291650e4f987c06db9f6decb206f53a11c584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b44668d086f298d344b2036a7cd0722e7825571bcc32d2b42b45b50a326cbdd"
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
