class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.7.3.tar.gz"
  sha256 "37f4bc0177534782609ec3a67ec413548d3f2cabff7c4c0bc8a92a36e49c6877"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1febdf95d90161093914f0b130a2e560e3e536316b414ab4d894195f2ffbec61"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e9185c5fb43ee4aa892bd5e9460fba19874c741df8cb0791af25ec7dab40575"
    sha256 cellar: :any_skip_relocation, catalina:      "eff4da14356490588c31bbdf4d327605c5209957956d2964eb42e65bb9f687ba"
    sha256 cellar: :any_skip_relocation, mojave:        "f57fdcf4118acc46b507b6e091f8898f9f1200f5041d20460ac97cc57fe21364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c0e6d39df1e8c28c0ed815df4a2f02a3e302a758fb9dade1aaf3d13212ce5ad"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    system bin/"stack", "new", "test"
    assert_predicate testpath/"test", :exist?
    assert_match "# test", File.read(testpath/"test/README.md")
  end
end
