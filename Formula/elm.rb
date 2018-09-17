require "language/haskell"

class Elm < Formula
  include Language::Haskell::Cabal

  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/0.19.0.tar.gz"
  sha256 "494df33724224307d6e2b4d0b342448cc927901483384ee4f8cfee2cb38e993c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5934d1b214fd2449b1a0222ad5c7b97b7309a21c97078634d6b32b3191dddc45" => :mojave
    sha256 "4655392e3e985c90f9e23b03438a8587475b48c1e1b0dabc2d74358f1b06daef" => :high_sierra
    sha256 "e0e45eb3388efe4a8147a65121d067ffad875952146c11519e8e564095de139b" => :sierra
    sha256 "e2a5f47750fb6a487e5220a3ac234b209acdb7edcde7e42c2ebe2507f8a3a5cf" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    # elm-compiler needs to be staged in a subdirectory for the build process to succeed
    (buildpath/"elm-compiler").install Dir["*"]

    cabal_sandbox do
      cabal_sandbox_add_source "elm-compiler"
      cabal_install "--only-dependencies", "elm"
      cabal_install "--prefix=#{prefix}", "elm"
    end
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
        "elm-version": "0.19.0",
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
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_predicate out_path, :exist?
  end
end
