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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5a6210196dee0e200e43a9c96606b57e12bcd8e05f9b796054a5211dbd083e84"
    sha256 cellar: :any,                 arm64_sequoia: "bfb374b171dbb31a919feb4277b0c275240f91864b2be5ae93e7ad4edcca4704"
    sha256 cellar: :any,                 arm64_sonoma:  "a14d7b05ef2da34ca9d67e61fd156f855eba8797f6ce85201feaea808b1fc401"
    sha256 cellar: :any,                 sonoma:        "a875b5c498abac130f39b8c761f72e17939ef20b62aa43d644514c7ae152c98f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "715b1de3a4287fae76ef766a48a18368506a0e9a492972c04c4e874d180005b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437c747e37c7bbecdbd63b829c2cd8de19d260560a4917091a7851472a55a78a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove locked dependencies which only work with a single patch version of GHC.
    # If there are issues resolving dependencies, then can consider bootstrapping with stack instead.
    (buildpath/"cabal.project").unlink
    (buildpath/"cabal.project").write <<~EOS
      packages: .
    EOS

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args

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
