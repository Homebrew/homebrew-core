require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.2.0.tar.gz"
  sha256 "a5160da66cdfb376df0ed87f0abb9dbc7feaa4efe77bcc7f9cc3b97425bc57f7"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "7d878126d8a6317d8325f3f434884eb52fadb6dd712433e18437979531e1e2df" => :high_sierra
    sha256 "2944aae8e9baf286e1c46814d88e0487f08a0bdd8279859475de0a9128f772df" => :sierra
    sha256 "6e9af20653598297ee21e83c9b7cb44240b7a8797d22bf918548a8cde6f45fdf" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    args = ["-f", "FFI"]
    args << "-f" << "release" if build.stable?
    install_cabal_package *args
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

    if build.with? "libffi"
      (testpath/"ffi.idr").write <<~EOS
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
