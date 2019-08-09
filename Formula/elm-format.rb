require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal

  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag      => "0.8.2",
      :revision => "ab3627cce01e5556b3fe8c2b5e3d92b80bfc74af"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "723a1df0e7f4c28d99b245ca1222b1bfd24f728d4eba2fbc95244437a95ea8d0" => :mojave
    sha256 "5b31e9ef6c2444befe736dfbde6253c6a259117f4458d5c2e04ec6d0a23a8877" => :high_sierra
    sha256 "4af61266dd8e30c3a57be137916f164d2f51a74e6e6a35aa85a5271061f15572" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def build_elm_format_conf
    <<~EOS
      module Build_elm_format where

      gitDescribe :: String
      gitDescribe = "#{version}"
    EOS
  end

  def install
    defaults = buildpath/"generated/Build_elm_format.hs"
    defaults.write(build_elm_format_conf)

    (buildpath/"elm-format").install Dir["*"]

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format", "--elm-version=0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format", "--elm-version=0.19", testpath/"Hello.elm", "--yes"
  end
end
