require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag => "0.6.1-alpha",
      :revision => "24cbc66245289dd3ca5c08a14e86358dc039fcf3"
  version "0.6.1-alpha"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d803f1ba6449fc85db9edac0bf55f14c9358868b015559ec2836c799bdf9cb4" => :sierra
    sha256 "034a1da2a60646992a7571e1879f6ff31ebc43c3f43250689d4b6d6f1c12286d" => :el_capitan
    sha256 "964df8c9e60c3ab2968fa6d6304beee5d0eefd993001a35e26da279b54e2e543" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<-EOS.undent
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format-0.17", testpath/"Hello.elm", "--yes"
  end
end
