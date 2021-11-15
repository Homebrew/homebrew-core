class Elm < Formula
  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/0.19.1.tar.gz"
  sha256 "aa161caca775cef1bbb04bcdeb4471d3aabcf87b6d9d9d5b0d62d3052e8250b1"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce89444a740bfc41ae2a03006171af4fb21dd2659164b5f68ff7fed681b214bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7efd5b1f3446827c5c06502a65c4bf80cabde7ecf11156e206a373d0c568af35"
    sha256 cellar: :any_skip_relocation, monterey:       "fef837b97895efeb899730e1381953b637f34910dd9e94d8c0a60e1da00d4b32"
    sha256 cellar: :any_skip_relocation, big_sur:        "8054bda935a4760f4cfd799f2bef0bb8fd2b25c10cc2d1fc1c0824625eaf30a3"
    sha256 cellar: :any_skip_relocation, catalina:       "0df96547e648ed70d25f67cbec301e8b1e9af814da5dba059c0c54cb594d1d0d"
    sha256 cellar: :any_skip_relocation, mojave:         "a826ba1bd9a92f3a5384a772533bf90c8d87e5f6c4ca8f30a6877c10ee9bab2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "810bfd7c5a40e9c6f4bae78af527acf2df4fbea11bc1af632526e90429fb68e0"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  patch do
    # elm's tarball is not a proper cabal tarball, it contains multiple cabal files.
    # Add `cabal.project` lets cabal-install treat this tarball as cabal project correctly.
    # https://github.com/elm/compiler/pull/2159
    url "https://github.com/elm/compiler/commit/eb566e901a419a6620e43c18faf89f57f0827124.patch?full_index=1"
    sha256 "556ff15fb4d8e5ca6e853280e35389c8875fa31a543204b315b55ec2ac967624"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    # create elm.json
    elm_json_path = testpath/"elm.json"
    elm_json_path.write <<~EOS
      {
        "type": "application",
        "source-directories": [
                  "."
        ],
        "elm-version": "0.19.1",
        "dependencies": {
                "direct": {
                    "elm/browser": "1.0.0",
                    "elm/core": "1.0.0",
                    "elm/html": "1.0.0"
                },
                "indirect": {
                    "elm/json": "1.0.0",
                    "elm/time": "1.0.0",
                    "elm/url": "1.0.0",
                    "elm/virtual-dom": "1.0.0"
                }
        },
        "test-dependencies": {
          "direct": {},
            "indirect": {}
        }
      }
    EOS

    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      module Hello exposing (main)
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_predicate out_path, :exist?
  end
end
