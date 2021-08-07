class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.5",
      revision: "80f15d85ee71e1663c9b53903f2b5b2aa444a3be"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "f7f6bb421efb3969733d33c7f6200af334bcd768d2128b14ba0280270b2fff30"
    sha256 cellar: :any_skip_relocation, catalina:    "dca23c0c1e66cfc6208ff891611ba8c38fdddd1d90d2a8b32bafe69dc3701b91"
    sha256 cellar: :any_skip_relocation, mojave:      "0e196d773546e0d476c079a434c57f1b49a2966410397bb33747fa2d9e57ffe1"
    sha256 cellar: :any_skip_relocation, high_sierra: "a8f9aa324518559cdd5b7617f5453f629e90f6897cd72e38f5ab84165e7ddae0"
  end

  depends_on "cabal-install" => :build
  depends_on "haskell-stack" => :build
  depends_on arch: :x86_64 # no ghc (OSX,AArch64) binary via `haskell-stack`

  uses_from_macos "xz" => :build # for `haskell-stack` to unpack ghc

  on_linux do
    depends_on "gmp" # for `haskell-stack` to configure ghc
  end

  def install
    # Currently, dependency constraints require an older `ghc` patch version than available
    # in Homebrew. Try using Homebrew `ghc` on update. Optionally, consider adding `ghcup`
    # as a lighter-weight alternative to `haskell-stack` for installing particular ghc version.
    jobs = ENV.make_jobs
    ENV.deparallelize { system "stack", "setup", "-j#{jobs}", "--stack-root", buildpath/".stack" }
    ENV.prepend_path "PATH", Dir[buildpath/".stack/programs/*/ghc-*/bin"].first
    system "cabal", "v2-update"

    # Directly running `cabal v2-install` fails: Invalid file name in tar archive: "avh4-lib-0.0.0.1/../"
    # Instead, we can use the upstream's build.sh script, which utilizes the Shake build system.
    system "./build.sh", "--", "build"
    bin.install "_build/elm-format"
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
