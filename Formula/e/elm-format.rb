class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.8",
      revision: "d07fddc8c0eef412dba07be4ab8768d6abcca796"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5056133df57fc96439054e34f04ec081bf08d317eefea981336c786a94dd8c2f"
    sha256 cellar: :any,                 arm64_sequoia: "793a01a476060deff0126e922ff4e6bf3d7f6d4666ee2e2ffa76114036a7838d"
    sha256 cellar: :any,                 arm64_sonoma:  "15e2ac52c016433bd4ca81958a352dc32d2ce8b309590001bf5cfeef87574941"
    sha256 cellar: :any,                 arm64_ventura: "1f6526cc7adeb4fc019894188906cd9130f69a02912a73b1599394c16a777f9a"
    sha256 cellar: :any,                 sonoma:        "6586c687d47970c27ec7a1d5ece3a71b0137ef72f3d6e13db501a9e2d3be5dd5"
    sha256 cellar: :any,                 ventura:       "4895173ac11f28d140d23c7795ec46a17252862b99b8b17cb762a01e0c2f7e65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f9b5d8604a3e94980d6b41a8655abfedef71dd6c8407ab2f96a52c04446e64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0077781afea83af1e8bd983239763b30fae56285f04f86e4a03a849cd87b8f43"
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

    system "cabal", "v2-update"

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
