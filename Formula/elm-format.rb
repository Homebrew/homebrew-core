require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal

  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag => "0.8.0",
      :revision => "f19ac28046d7e83ff95f845849c033cc616f1bd6"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b0169fc746c7f5cb58c42398ed2d27293bd0fbe7e03c79a20772e40e2b87b7c" => :mojave
    sha256 "a1047123c27bd64f9ee8a9105abfcf2e474cb76cee9c33c815ffb148f8864968" => :high_sierra
    sha256 "5af4a51247a7ed87cb10e5a68d42fdd29441ea943cb97aefde67ba73e562718e" => :sierra
    sha256 "81ceb798aab9192629dfe1b98b91dfcaec272db1c83eba9c662f90f8e776d0fa" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    # GHC 8.4.1 compat
    # Reported upstream 21 Mar 2018 https://github.com/avh4/elm-format/issues/464
    (buildpath/"cabal.config").write <<~EOS
      allow-newer: elm-format:free, elm-format:optparse-applicative
      constraints: free < 6, optparse-applicative < 0.15
    EOS

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

    system bin/"elm-format-0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format-0.19", testpath/"Hello.elm", "--yes"
  end
end
