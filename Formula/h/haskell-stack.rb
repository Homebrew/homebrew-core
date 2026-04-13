class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v3.9.3.tar.gz"
  sha256 "144bc7eaaf384228f6b0f960ced130b503dc4945ffa42f3ca2037abbc8136c05"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "966bac3da41b3141075c09addb159676fbb19da6d720a277e892504d465336ea"
    sha256 cellar: :any,                 arm64_sequoia: "3e73b1dbc050a2df69198f99cb120138947f69e8a4c97afb8d5a6494e525fa5c"
    sha256 cellar: :any,                 arm64_sonoma:  "ed684089667e38615fc512b86cada8061f76d5e5068b056bd9956dba54d148a3"
    sha256 cellar: :any,                 sonoma:        "8e4b8ace611090ae24e80d33046f7603d523bc66b2407e4ee44843e03a5ea6c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af0742873c1d14df060eb3e3efce2ffb20356838c6ca48c1676febd4bdcb63e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b6589ec069f26a6b7ff4cc21a94284d8a0c1c3df37ba74cbdec5f76c2b4b1db"
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
