class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.7",
      revision: "b5cca4c26b473dab06e5d73b98148637e4770d45"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "39551d3762854b22e3db540e1eb0187484cf50ce30233a70289ae0d6d29e1c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25f339b466676ecaa1be5b3d5fa0d49a1ea6c4a8593be06837e85695a93bebff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81d3cdebad68b53ebe6d615e9362359a433c371804e38c9ac274a6657ab4a972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95da1452e810b7b381ae898269325caa6da8a3224de231479a515ad9e8aaf6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "94f1a4809976df842ac5e63efcd66b564bf4cca7ff833c90a9218f3652956af2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c69440ab4cbdacc7518c70b98d9a60f111423c53674820e1afff2c174a80f5cc"
    sha256 cellar: :any_skip_relocation, ventura:        "61520c04f08cbd3b0f0989718fb8b3df92ce41d2f1b2f68c1827bc4d0331e482"
    sha256 cellar: :any_skip_relocation, monterey:       "65b60d85cf68821087e2d5005778d552c15d7183d763bcdb893da033ec21ac38"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0f4b8bde75fc24c1e8a3ab6693581a210f9c8a8886de800835c5623261e4fc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b1ec84983f60bd9a7834c03074931a6f7a1c78ac640a4c6b94cbc1a10bb968"
  end

  # Has been using pre-built GHC due to needing specific patch version of GHC
  deprecate! date: "2024-07-27", because: "does not build with any GHC formula"

  depends_on "cabal-install" => :build
  depends_on "haskell-stack" => :build
  depends_on "hpack" => :build

  uses_from_macos "xz" => :build # for `haskell-stack` to unpack ghc

  on_linux do
    depends_on "gmp" # for `haskell-stack` to configure ghc
  end

  def install
    # Currently, dependency constraints require an older `ghc` patch version than available
    # in Homebrew. Try using Homebrew `ghc` on update. Optionally, consider adding `ghcup`
    # as a lighter-weight alternative to `haskell-stack` for installing particular ghc version.
    jobs = ENV.make_jobs
    ENV.deparallelize { system "stack", "-j#{jobs}", "setup", "9.2.5", "--stack-root", buildpath/".stack" }
    ENV.prepend_path "PATH", Dir[buildpath/".stack/programs/*/ghc-*/bin"].first
    system "cabal", "v2-update"

    # Directly running `cabal v2-install` fails: Invalid file name in tar archive: "avh4-lib-0.0.0.1/../"
    # Instead, we can use the upstream's build.sh script, which utilizes the Shake build system.
    system "./dev/build.sh", "--", "_build/bin/elm-format/O2/elm-format"
    bin.install "_build/bin/elm-format/O2/elm-format"
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format", "--elm-version=0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format", "--elm-version=0.19", testpath/"Hello.elm", "--yes"

    assert_match version.to_s, shell_output("#{bin}/elm-format --help")
  end
end
