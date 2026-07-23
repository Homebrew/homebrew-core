class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.8",
      revision: "d07fddc8c0eef412dba07be4ab8768d6abcca796"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "0db604c0ea1d3054599a10069285102c10c6ba52a24b677be8324818cd6caad4"
    sha256 cellar: :any, arm64_sequoia: "e53fca4d0305acccb8a16a07043dddd5a43a2651da19ec917ef18f8b6395aee1"
    sha256 cellar: :any, arm64_sonoma:  "714903c2dda4ae3a054d90c371be7892a412a69da4558ec9a6f8e34f9baf4b84"
    sha256 cellar: :any, sonoma:        "f7201cc2c1179e94a4bcff25fa08e8e28d5191442d70adf77275ae338646377c"
    sha256 cellar: :any, arm64_linux:   "718d8c84b8703f4473980f65044f94d6935ed50b03fee6ac679527696e06c2fe"
    sha256 cellar: :any, x86_64_linux:  "40d25c1e6f06c0117822346508af98d3389399aa23236c0f4fcf5d2a06eb120a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    # Remove requirement on specific patch GHC
    (buildpath/"cabal.project.freeze").truncate(0)
    inreplace "cabal.project", /^with-compiler: .*$/, ""

    args = std_cabal_v2_args.reject { |s| s["install"] }
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args << "--allow-newer=base,containers,template-haskell"

    system "cabal", "v2-update"
    system "cabal", "v2-configure", *args

    # Directly running `cabal v2-install` fails: Invalid file name in tar archive: "avh4-lib-0.0.0.1/../"
    # Instead, we can use the upstream's build.sh script, which utilizes the Shake build system.
    system "./dev/build.sh", "--", "_build/bin/elm-format/O2/elm-format"
    bin.install "_build/bin/elm-format/O2/elm-format"
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~ELM
      import Html exposing (text)
      main = text "Hello, world!"
    ELM

    system bin/"elm-format", "--elm-version=0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format", "--elm-version=0.19", testpath/"Hello.elm", "--yes"

    assert_match version.to_s, shell_output("#{bin}/elm-format --help")
  end
end
