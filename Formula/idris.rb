require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.0.tar.gz"
  sha256 "aaed0d01c0395cb7cac2562f689f8589072ad7568acaeb5e20451ffeebab963e"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "fe5231d29fbf3927e83ae1add29ae9b86fd94a13771e94a4a0dc4316b1d1f4b3" => :sierra
    sha256 "f9ca5a80a938c2089cf2b4873220f6329e0e98b2bc5d998f7fe1c1afc447b9cf" => :el_capitan
    sha256 "8fed2cb59d66a0990aeed6ab21c10e6e45d5517bbc8c14ed8061458f8334a0ac" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "libffi" => :recommended

  # Remove once trifecta > 1.6 is released to Hackage
  # Fix "Couldn't match type 'Parser' with 'IdrisInnerParser' ..."
  # Upstream commit from 27 Oct 2016 "Remove redundant constraint in DeltaParsing method"
  # See http://git.haskell.org/ghc.git/blob/HEAD:/docs/users_guide/8.0.2-notes.rst#l32
  resource "trifecta-patch" do
    url "https://github.com/ekmett/trifecta/commit/aaa47fa.patch"
    sha256 "eb5d36506461d6caae38b27ca7d9045d69efb3dea3fe718b44ee97a719feca1c"
  end

  def install
    args = []
    args << "-f FFI" if build.with? "libffi"
    args << "-f release" if build.stable?

    cabal_sandbox do
      system "cabal", "get", "trifecta"
      resource("trifecta-patch").stage do
        system "patch", "-p1", "-i", Pathname.pwd/"aaa47fa.patch", "-d",
                        buildpath/"trifecta-1.6"
      end
      cabal_sandbox_add_source "trifecta-1.6"
      install_cabal_package *args
    end
  end

  test do
    (testpath/"hello.idr").write <<-EOS.undent
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

    if build.with? "libffi"
      (testpath/"ffi.idr").write <<-EOS.undent
        module Main
        puts: String -> IO ()
        puts x = foreign FFI_C "puts" (String -> IO ()) x
        main : IO ()
        main = puts "Hello, interpreter!"
      EOS

      system bin/"idris", "ffi.idr", "-o", "ffi"
      assert_equal "Hello, interpreter!", shell_output("./ffi").chomp
    end
  end
end
