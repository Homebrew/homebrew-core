require "language/haskell"

class Elm < Formula
  include Language::Haskell::Cabal

  desc "Functional programming language for building browser-based GUIs"
  homepage "http://elm-lang.org"

  stable do
    url "https://github.com/elm-lang/elm-compiler/archive/0.17.1.tar.gz"
    sha256 "3339b79696981b76a719c651bda18082f4ecc58e01d913b29b202f174665e387"

    resource "elm-package" do
      url "https://github.com/elm-lang/elm-package/archive/0.17.1.tar.gz"
      sha256 "f7f9ede1066fe55e0f9e94906fdda0e4a0f56efeb12de8481bc5f5b96b78d33d"
    end

    resource "elm-make" do
      url "https://github.com/elm-lang/elm-make/archive/0.17.1.tar.gz"
      sha256 "918316f65fc8cac1f6fe8cffa9b86aeff3d9d9a446559db43ec7c87e1dc78d95"
    end

    resource "elm-repl" do
      url "https://github.com/elm-lang/elm-repl/archive/0.17.1.tar.gz"
      sha256 "01621479d798f906d90c2bff77fdefe4a76b1855241efc9a3530d4febcdee61b"
    end

    resource "elm-reactor" do
      url "https://github.com/elm-lang/elm-reactor/archive/0.17.1.tar.gz"
      sha256 "0778df7e7fad897c750c29024166234cf3b4fcebe664aa52d864e0b64691e5e0"
    end
  end

  bottle do
    revision 1
    sha256 "4f1136c3d7f7788539481f5d1d849447933c7e45afe97ec0e82601e7da89f45d" => :el_capitan
    sha256 "fd6acc31a75ae65d3c90592c4dad93d8972ee001e200e42c679f89ce1931f566" => :yosemite
    sha256 "5cbfc6da062d7a87c3ac205d7689dacdd04455d22e184964327081c7f1cb4cb4" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  # GHC 8 compat
  # Fixes "No instance for (Num Json.Indent) arising from the literal '2'"
  # Reported 3 Jul 2016; PR subject "aeson-pretty: use Spaces with confIndent"
  patch do
    url "https://github.com/elm-lang/elm-compiler/pull/1431.patch"
    sha256 "4f11e645b4190eb3b0cbea7c641d4b28b307b811889f3b8206f45f6e53a5575b"
  end

  def install
    # elm-compiler needs to be staged in a subdirectory for the build process to succeed
    (buildpath/"elm-compiler").install Dir["*"]

    # GHC 8 compat
    # Fixes "cabal: Could not resolve dependencies"
    # Reported 25 May 2016: https://github.com/elm-lang/elm-compiler/issues/1397
    (buildpath/"cabal.config").write("allow-newer: base,time,transformers,HTTP\n")

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

    system bin/"elm", "package", "install", "elm-lang/html", "--yes"

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert File.exist?(out_path)
  end
end
