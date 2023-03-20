class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.6",
      revision: "7e80dd48dd9b30994e43f4804b2ea7118664e8e0"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e30b1ced1e42be3d4f7b2881876f7e2c4f85e4fbb867fba93bc78334c1200e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45548670240e259970da0af18431383b0ac2ddb99e0daf4d925eedee9707cdc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74b60c47df474cfa31de21ef623cd9fb8c30e45c8e144b3f12d958757b935ffe"
    sha256 cellar: :any_skip_relocation, ventura:        "31d555e9c93a0319cf969800588be60792b3eb8455c0a3847c11af27cbdfd2fe"
    sha256 cellar: :any_skip_relocation, monterey:       "52bee1af1d269f3f77c53076189e43108c1b6942a733aad8fdb9a4cb3b34f987"
    sha256 cellar: :any_skip_relocation, big_sur:        "096b137beeb4bd16c4fa03dcc4d6c103a321e59aa201cd862c6973cf19d2b1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f29eef6c114fad1b9aabece7232e56b18f5cdde3a05b7bd4b69557f225442635"
  end

  depends_on "cabal-install" => :build
  depends_on "haskell-stack" => :build

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
    system "./dev/build.sh", "--", "build"
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
