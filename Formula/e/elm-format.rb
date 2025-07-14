class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      tag:      "0.8.8",
      revision: "d07fddc8c0eef412dba07be4ab8768d6abcca796"
  license "BSD-3-Clause"
  head "https://github.com/avh4/elm-format.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "934f90684cfe8daa0b264f2a4f997b8b98799f2e4f520123bed0ff211faecb1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29a357d37c12d0d6d9d9d57ac44a767902b5bcce7d512377da3f9d77dd55d022"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2c86bbe7f7c8324c84dddf9084302ed4d9cdaf558eb2e9a209e72752eb2ba80"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d4770210d28927ef60c216da3d5f98aa697b072a91ff3e0f56150da8f9d6493"
    sha256 cellar: :any_skip_relocation, ventura:       "094a9cb5819053751ee3ecf0460dc3db6a074674786eb922dfeabfbb2b1cb972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b83a2583d58fdb638d9e507218ce1b08e8f68f342f7ad203a1cb404ce00c427"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "hpack" => :build

  uses_from_macos "xz" => :build # for `haskell-stack` to unpack ghc

  on_linux do
    depends_on "gmp" # for `haskell-stack` to configure ghc
  end

  def install
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
