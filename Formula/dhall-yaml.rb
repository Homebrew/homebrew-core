class DhallYaml < Formula
  desc "Convert between Dhall and YAML"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-yaml"
  url "https://hackage.haskell.org/package/dhall-yaml-1.2.8/dhall-yaml-1.2.8.tar.gz"
  sha256 "5359f4d4e0f8aa96ef5d6788e33654a508b6c38130d4034b146eacc89737e6dc"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca43581e426e62cd9bf97a54b7346aaa6b2ead264fdda3a37f5ac6c47b8b23f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a01cad7832672edda803711fd85feb441209a796eb0888cbb99ed56c6bebb657"
    sha256 cellar: :any_skip_relocation, monterey:       "f0848538919c411a5f50eaf267a4f12109caf09d8eb3f8810c37be7d61051e71"
    sha256 cellar: :any_skip_relocation, big_sur:        "26a59e11de9af4b90c79e9ff7be84bf1338583073e6998ecff90a08e0075eb64"
    sha256 cellar: :any_skip_relocation, catalina:       "c63f896511f1d4d9ef17c90b76982711561363275ee1b181377b13dff50d32fa"
    sha256 cellar: :any_skip_relocation, mojave:         "8165c1454147b4f36b7fe9f6a83995c7b99655cb2741c064e19048649ffb9f1e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "1", pipe_output("#{bin}/dhall-to-yaml-ng", "1", 0)
    assert_match "- 1\n- 2", pipe_output("#{bin}/dhall-to-yaml-ng", "[ 1, 2 ]", 0)
    assert_match "null", pipe_output("#{bin}/dhall-to-yaml-ng", "None Natural", 0)
  end
end
