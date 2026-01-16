class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.42.3/dhall-1.42.3.tar.gz"
  sha256 "cbb5612d9c55b9b3fa07ab73b72e6445875a6f53283f29979f164a9b3b067a00"
  license "BSD-3-Clause"

  livecheck do
    url "https://hackage-content.haskell.org/package/dhall/docs/"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0c88f6d849e606972f088b676e385fb3b866aec93107728074e63579442ce15"
    sha256 cellar: :any,                 arm64_sequoia: "5c4e5006b8fbe7f851df1f5715b6132e0bf0f2e9d175f8c6869a43cf82832f8b"
    sha256 cellar: :any,                 arm64_sonoma:  "0fe7073e00a30ea6e6344188bffaa2b361919ea319b6fb9fab59b21de4842afe"
    sha256 cellar: :any,                 sonoma:        "27ca6fd8b3d000043651b6e32fc038774afa3bd77be1ce99d410c9c641cc45d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65ae741e47d6ecbfa5f775056e10a2247b79f0543bacf0d1621898e3a1dadd17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cf559101a33d814532fa5dce8daaabc235e1fcebf71bff4313a57d3f96cb0dc"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "man/dhall.1"
  end

  test do
    assert_match "{=}", pipe_output("#{bin}/dhall format", "{ = }", 0)
    assert_match "8", pipe_output("#{bin}/dhall normalize", "(\\(x : Natural) -> x + 3) 5", 0)
    assert_match "(x : Natural) -> Natural", pipe_output("#{bin}/dhall type", "\\(x: Natural) -> x + 3", 0)
  end
end
