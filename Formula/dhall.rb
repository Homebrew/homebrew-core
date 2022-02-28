class Dhall < Formula
  desc "Interpreter for the Dhall language"
  homepage "https://dhall-lang.org/"
  url "https://hackage.haskell.org/package/dhall-1.41.1/dhall-1.41.1.tar.gz"
  sha256 "9bea36ab0e1c965aef7474fabea67c3cfa3ca272007508ecd7bf22eaaae8d425"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e079ff66385d346a3f8fc53d9364bac2e28fb362fd10268c162775c9cc976733"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28d158f3b6806696debb26dd9eb8b93bd952266788adc2a99f6a953b9a6bae95"
    sha256 cellar: :any_skip_relocation, monterey:       "cb99eaed623aa732a18f0b1078a27fac36ae46ba5d22e7250ca467c7e6add498"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02655ca8842ff04324f4ea67d08cb73201e874b792006e7db9bb8cbb5ff189c"
    sha256 cellar: :any_skip_relocation, catalina:       "2ecbf911a9e975ed2fa129e082e6a85cfaa238f3b6d72b3f3a19bdf5c82f0d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9262f5f74ef22618e7549027b50a5d8066e6f3b2544f66e8e1dea791fd383f2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

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
