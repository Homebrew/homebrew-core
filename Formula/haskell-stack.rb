class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/v2.7.1.tar.gz"
  sha256 "eb849d5625084a6de57e8520ddf8172aca64ddadd9fee37cdafeefad80895b62"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/commercialhaskell/stack.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "d8b72126d7ceaea59f2782116ec614f1c74b36709d4df71be68632b3de8525ac"
    sha256 cellar: :any_skip_relocation, catalina: "39a5f47f91b0095d329793e351292e0d3c1e24f197d368fa08d564b4887cf291"
    sha256 cellar: :any_skip_relocation, mojave:   "d5a85f265e0c0aba503f035469c0fa7aca81e5029e6c7b5eb3b28461b929fddb"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gmp"
  end

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
