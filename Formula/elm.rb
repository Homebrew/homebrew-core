require "language/haskell"

class Elm < Formula
  include Language::Haskell::Cabal

  desc "Functional programming language for building browser-based GUIs"
  homepage "http://elm-lang.org"

  stable do
    url "https://github.com/elm-lang/elm-compiler/archive/0.17.tar.gz"
    sha256 "61544685d45d9557cd768ddaa820ec0cfd5bac233b141a0d8b21fb100b06eb37"

    resource "elm-package" do
      url "https://github.com/elm-lang/elm-package/archive/0.17.tar.gz"
      sha256 "108a89ff1db031c0eee6ca0bdb1289415012519f0311a804bc067bd03f4c6877"
    end

    resource "elm-make" do
      url "https://github.com/elm-lang/elm-make/archive/0.17.tar.gz"
      sha256 "6a39cae249d848f823b8bc0c932240eb5d56c42c46998406168917444eca8890"
    end

    resource "elm-repl" do
      url "https://github.com/elm-lang/elm-repl/archive/0.17.tar.gz"
      sha256 "be41caf0140dff8493177cfcf60cc3ff3b9d35e7e90f242818369485ef8b7f9e"
    end

    resource "elm-reactor" do
      url "https://github.com/elm-lang/elm-reactor/archive/0.17.tar.gz"
      sha256 "278efc50756bca4f95f905e98f661c053a09d063e7140b0d11363ee14b60a79e"
    end
  end

  bottle do
    sha256 "af4973a6501741e69289163297cb1f3f20f1837dbca7c38ca8fc7cf8116a8460" => :el_capitan
    sha256 "8e768f845671c3e83197abd99cb4e07bea0c2cdaa293023fe27fbb7b5f90cb19" => :yosemite
    sha256 "631587361e3e35dbd6677de2c6b580bd88b5ed04835c8b6ca763649d98579da7" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # elm-compiler needs to be staged in a subdirectory for the build process to succeed
    (buildpath/"elm-compiler").install Dir["*"]

    extras_no_reactor = ["elm-package", "elm-make", "elm-repl"]
    extras = extras_no_reactor + ["elm-reactor"]
    extras.each do |extra|
      resource(extra).stage buildpath/extra
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
    src_path.write <<-EOS.undent
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm", "package", "install", "evancz/elm-html", "--yes"

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert File.exist?(out_path)
  end
end
