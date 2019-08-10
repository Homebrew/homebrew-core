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
    sha256 "31144028047fc2d4abf834bafcc2db54f20c516984c151ea5fba94371b28d4c7" => :mojave
    sha256 "be14a5786096c3c76b60eb87160359230b78be1de602c859d4b35a422275e981" => :high_sierra
    sha256 "81499738a7d79d0cd2b4aa2645f4f8b450b6da9e3e293d9f595bc5f082ca9e08" => :sierra
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
