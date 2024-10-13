class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.42.1/dhall-1.42.1.tar.gz"
  sha256 "ce8cfa44978091811e7c77eb6d2a80cbc55b4582045a0740c44e277af4388758"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "92267cccea4fb48297611e098da0a5491a51e9a5b0e2ed1caab6d19c787a3855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b3adf9545d76acec8f309f2da83bcb9abc68f0784aad85bf63d06fde76d8d54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a889ca9eed3abcf80ba989c87c2f4ad05c24a8573111583a30f3472ee2d0cc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b622f20190b66b0fa9ec8f16d64362a947bc42c24e59c7d1fd6ed6beb409b5e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "15fb244a17c75722afa0a9bd91dcc9bd6d5e5a9199dd13a90d53cfa3e0dcc32b"
    sha256 cellar: :any_skip_relocation, ventura:        "1472b8bf61529a95c24194c687ebca6ce63532b892bf1b35a0c2259e2d4988c5"
    sha256 cellar: :any_skip_relocation, monterey:       "b27780c04e7356aa4fbb7f2048f65018d5d350353d35de0e5b2fc38b12cff5a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a8ab1009b2d55712c6d750089ced06662fde31d729961e9d3159dc78be724f0"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

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
