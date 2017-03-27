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
    sha256 "61ad938bc44efb57e575b7ae1da584d81e07ab114979bd54d294933675d4c12b" => :sierra
    sha256 "ddcfbf0941cd76df534000aa01062c354f2d8788ca7b2ef93e37fcf8ed029b88" => :el_capitan
    sha256 "6b1b4cbb6da1aad3a80cd61190694b2e8ab19f5114eae8641ad1b0fc6ceaa1ed" => :yosemite
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
