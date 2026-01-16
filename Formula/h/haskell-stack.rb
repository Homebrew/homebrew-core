class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "9e3a40df6bcf3ca012d5b924eaf3b5b24563bfe07a6b4ed20098b73b15870c54"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6b50ab326697af395bb385a55167324d1f2eab1fcf52faf71b95cd25531153e"
    sha256 cellar: :any,                 arm64_sequoia: "febdcc3b72055ced04faa19d5fcc48d1cbc419f0474d0a9f42f893935f6daa27"
    sha256 cellar: :any,                 arm64_sonoma:  "428c6647e21e176a6988b959d8ef8aa1096b4149f07463274fda2214adfe165c"
    sha256 cellar: :any,                 sonoma:        "4cedb63d472a8daefbf529b612549a0fc37bcd0b0c7c5ac6c646dea62ffbe5d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f0ed813cb29ccfd1e78d237dc9dd1e4bd35d0901cd0df760c31bdff2ec7856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302102c37c197fad07cfb8e35d34de036e27708558f796e836813bdfc889c81b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  def install
    # Remove locked dependencies which only work with a single patch version of GHC.
    # If there are issues resolving dependencies, then can consider bootstrapping with stack instead.
    (buildpath/"cabal.project").unlink
    (buildpath/"cabal.project").write <<~EOS
      packages: .
    EOS

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    [:bash, :fish, :zsh].each do |shell|
      generate_completions_from_executable(bin/"stack", "--#{shell}-completion-script", bin/"stack",
                                           shells: [shell], shell_parameter_format: :none)
    end
  end

  test do
    system bin/"stack", "new", "test"
    assert_path_exists testpath/"test"
    assert_match "# test", (testpath/"test/README.md").read
  end
end
