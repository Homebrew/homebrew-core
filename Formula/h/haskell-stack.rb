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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b2f986313c4ee456d9d790c70784bd7d42bfbb42340620f855d6feaf1704dfe1"
    sha256 cellar: :any, arm64_sequoia: "d37bbf5226d1537437cdd3c52c83f1042fafd02425f700caee0c7a37906a76c4"
    sha256 cellar: :any, arm64_sonoma:  "1112bf679a87e281a3f975d85dbe8d167b765ac62e187c71665cee82289fce66"
    sha256 cellar: :any, sonoma:        "acdf16539f35a64471a7f1d7d0ef1eac58e0f8f046cf301c21093b492935e9b9"
    sha256 cellar: :any, arm64_linux:   "80a7c608538746562744ac54033a1638a37a3722e982c430756c5a9c1aba9695"
    sha256 cellar: :any, x86_64_linux:  "d93c120626eedc29ab2c5c374f759ceb0b30a359096690aa66f119944f00d928"
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

    # Workaround to build persistent with GHC 9.14, https://github.com/yesodweb/persistent/issues/1619
    args = ["--allow-newer=template-haskell"]

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
