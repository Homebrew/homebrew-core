require "language/haskell"

class Elm < Formula
  include Language::Haskell::Cabal

  desc "Functional programming language for building browser-based GUIs"
  homepage "http://elm-lang.org"

  stable do
    url "https://github.com/elm-lang/elm-compiler/archive/0.18.0.tar.gz"
    sha256 "3ed70ab6e624c09dd251bb2f1e104752ebd3f50a062ddf92fff9cbec98d09850"

    resource "elm-package" do
      url "https://github.com/elm-lang/elm-package/archive/0.18.0.tar.gz"
      sha256 "5cf6e1ae0a645b426c0474cc7cd3f7d1605ffa1ac5756a39a8b2268ddc7ea0e9"

      # Fix two "Not in scope" errors
      # Upstream PR from 3 Oct 2017 "Paths.hs: fix build failure"
      patch do
        url "https://github.com/elm-lang/elm-package/pull/287.patch?full_index=1"
        sha256 "3f922d7962a41217e760361ad444d00676aff0e40c3741fd536b39d2961165d3"
      end
    end

    resource "elm-make" do
      url "https://github.com/elm-lang/elm-make/archive/0.18.0.tar.gz"
      sha256 "00c2d40128ca86454251d6672f49455265011c02aa3552a857af3109f337dbea"
    end

    resource "elm-repl" do
      url "https://github.com/elm-lang/elm-repl/archive/0.18.0.tar.gz"
      sha256 "be2b05d022ffa766fe186d5ad5da14385cec41ba7a4b2c18f2e0018351c99376"
    end

    resource "elm-reactor" do
      url "https://github.com/elm-lang/elm-reactor/archive/0.18.0.tar.gz"
      sha256 "736f84a08b10df07cfd3966aa5c7802957ab35d6d74f6322d4a69a0b9d75f4fe"
    end
  end

  bottle do
    sha256 "4a7232fc62d4c340ddf49f6e63924734f66f5cb0861ea4fc042d41cebc139884" => :high_sierra
    sha256 "64f0a490d8bce84b1541a2a219c7298d515d64b3042bb48c41d52f83adf9260d" => :sierra
    sha256 "1c3f415cf011dbadc6265a22fd1671c2461f3e906cecc54172b67c7295b28344" => :el_capitan
    sha256 "428fb7d2719fee543d9cc8a5e25d0cbd697fe447e585e322f01f29f35fcc1011" => :yosemite
  end

  depends_on "ghc@8.0" => :build
  depends_on "cabal-install" => :build

  def install
    # elm-compiler needs to be staged in a subdirectory for the build process to succeed
    (buildpath/"elm-compiler").install Dir["*"]

    extras_no_reactor = ["elm-package", "elm-make", "elm-repl"]
    extras = extras_no_reactor + ["elm-reactor"]
    extras.each do |extra|
      resource(extra).stage buildpath/extra
    end

    # https://github.com/elm-lang/elm-make/pull/130
    inreplace "elm-make/elm-make.cabal", "optparse-applicative >=0.11 && <0.12,",
                                         "optparse-applicative >=0.11 && <0.14," # 0.13.0.0 is current

    # https://github.com/elm-lang/elm-package/pull/252
    inreplace "elm-package/elm-package.cabal" do |s|
      s.gsub! "optparse-applicative >= 0.11 && < 0.12,",
              "optparse-applicative >= 0.11 && < 0.14," # 0.13.0.0 is current
      s.gsub! "HTTP >= 4000.2.5 && < 4000.3,",
              "HTTP >= 4000.2.5 && < 4000.4," # 4000.3.3 is current
    end

    cabal_sandbox do
      cabal_sandbox_add_source "elm-compiler", *extras
      cabal_install "--only-dependencies", "elm-compiler", *extras
      cabal_install "--prefix=#{prefix}", "elm-compiler", *extras_no_reactor

      # elm-reactor needs to be installed last because of a post-build dependency on elm-make
      ENV.prepend_path "PATH", bin

      cabal_install "--prefix=#{prefix}", "elm-reactor"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm", "package", "install", "elm-lang/html", "--yes"

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_predicate out_path, :exist?
  end
end
