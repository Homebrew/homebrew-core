class HaskellStack < Formula
  desc "Cross-platform program for developing Haskell projects"
  homepage "https://haskellstack.org/"
  url "https://github.com/commercialhaskell/stack/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "388916c20e2a9e9d343ef40c0c31fbb664cdbf302122ded8508ded8f765cbb4f"
  license "BSD-3-Clause"
  head "https://github.com/commercialhaskell/stack.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4523cc57f76a0a71d0603dcf85e2e6e502d9ee07dd2e8c151c7fba2120c71b65"
    sha256 cellar: :any, arm64_sequoia: "ec3dc5be42d89efc0b511e1bbedef20968fd9d8762a7a11e14ad9dcd3b9cc3a2"
    sha256 cellar: :any, arm64_sonoma:  "0d45efb41df5506a38429b1e5061b7bc860a3444ae2edb400bd37e6cbfc74b7a"
    sha256 cellar: :any, sonoma:        "ee48a31fc1520113ec18d518e36b0ab5e4edb9a9e0b167f473090c98a3e79716"
    sha256 cellar: :any, arm64_linux:   "1b8c15ae51db3980c6fb7438d8005dbc284182cc04c61862ac2ee70575bb366b"
    sha256 cellar: :any, x86_64_linux:  "8a36c71b8ee3719d147a300d72e9520f336084739637f874e925c295ea44439d"
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
    (buildpath/"cabal.project").write <<~CABAL
      packages: .
    CABAL

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
