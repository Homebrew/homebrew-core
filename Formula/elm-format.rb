class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.5",
      revision: "80f15d85ee71e1663c9b53903f2b5b2aa444a3be"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "9066d69a558d83fd34502c7a8949213fbd8c62314d6020e7bf83bf533b48ff87"
    sha256 cellar: :any_skip_relocation, catalina:     "934eed770e7b19d15cb01906b5e64124b4b6bb0c5a0272d52b70d20d98b3487d"
    sha256 cellar: :any_skip_relocation, mojave:       "fed548eb02c34faf688a6ac250b69bf4d5c6720e22213ea794542385bccee387"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "122e69e40ba66e45f3cae09c9e8d48a886a9cba6fa91ef10a0acc42134771621"
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
    ENV.deparallelize { system "stack", "-j#{jobs}", "setup", "8.10.4", "--stack-root", buildpath/".stack" }
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
