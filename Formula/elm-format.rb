require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal
  desc "Elm source code formatter, inspired by gofmt."
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag => "0.6.0-alpha",
      :revision => "6e79d9a5daf04d9e6d2c23b9098f50e59a734a8e"
  version "0.6.0-alpha"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cd25b6ada29a5847c5a16410bdd7f39c4a227f287384c9b9f7e7a3133bd4a46" => :sierra
    sha256 "8225e31530bf4ca54bb0075e677d49756f1c75911e5a6bd9e0825e1ae5ce7b7b" => :el_capitan
    sha256 "052148e71c7ff27ff221e25e388fda543e9d6f85a0a401cb08687ad700ee8302" => :yosemite
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
