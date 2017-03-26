require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.99.2.tar.gz"
  sha256 "a4051d6783b15c8e25dd401f0f1984a0597db47f8373388cc04e60f76961b4eb"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "a2985cccb1cdb4f4f8a3b900d1bdff2f5af8e10ea87424340c9c8683d5242fac" => :sierra
    sha256 "18dfe5fbc8ae359f5f9d87147fbcddccf87f34b6cb96afb08f08519b0371dd81" => :el_capitan
    sha256 "e9f5d2a9430b6353ed1508d5598770b5f01c93210aaa390f61f1d744139f55da" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "libffi" => :recommended

  def install
    args = []
    args << "-f FFI" if build.with? "libffi"
    args << "-f release" if build.stable?
    install_cabal_package *args
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
