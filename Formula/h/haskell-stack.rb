class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v3.5.1.tar.gz"
  sha256 "00de60eaefdba1aa289ed409a9cabe8d63f9f6d554018456ab7f78531b2c3629"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb81522eb7a165d7f1dc9650b1cc2bedacfb43cca1a08a0c960e5519a90f37a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b25f2852beeca1d67c7771142af9b81d404f9a1dae8985caf4641f6be33b0746"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58ed8f3b45ce0d96ef92ce596ee4aa8c898c2a004d3fa94ac5ac7aad3da10d7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5492d567c98c075d1312897d0afb4645f44d500814bce73785729f86f95099d7"
    sha256 cellar: :any_skip_relocation, ventura:       "27831d3d54f8b3b7ab1e59da20dedc67c8da46e85bb2c7379df0f1333af47a15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6a57d5ccfc7082cde45e9b926a774c7f3d455d2c693fa0f758e881328d0d8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfbfa1acd47505570bbb0b1989c824af5bc0b280f2003bbb10df1f2e566cab4d"
  end

  depends_on "cabal-install" => :build
  # https://github.com/commercialhaskell/stack/issues/6625#issuecomment-2228087359
  # https://github.com/commercialhaskell/stack/blob/master/stack-ghc-9.10.1.yaml#L4-L5
  depends_on "ghc@9.8" => :build # GHC 9.10+ blocked by Cabal 3.12+ API changes

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
