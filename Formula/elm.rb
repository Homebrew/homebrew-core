require "language/haskell"

class Elm < Formula
  include Language::Haskell::Cabal

  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/0.19.0.tar.gz"
  sha256 "494df33724224307d6e2b4d0b342448cc927901483384ee4f8cfee2cb38e993c"

  bottle do
    sha256 "4a7232fc62d4c340ddf49f6e63924734f66f5cb0861ea4fc042d41cebc139884" => :high_sierra
    sha256 "64f0a490d8bce84b1541a2a219c7298d515d64b3042bb48c41d52f83adf9260d" => :sierra
    sha256 "1c3f415cf011dbadc6265a22fd1671c2461f3e906cecc54172b67c7295b28344" => :el_capitan
    sha256 "428fb7d2719fee543d9cc8a5e25d0cbd697fe447e585e322f01f29f35fcc1011" => :yosemite
  end

  depends_on "ghc@8.2" => :build
  depends_on "cabal-install" => :build

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
