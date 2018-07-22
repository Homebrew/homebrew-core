require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.0.tar.gz"
  sha256 "8cce6c8bd24daf18b18f2f270354c711529bef6231b3c9016c3dcb98de6bca99"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "c40c05247f24827d330cf56e5bdb7d1c4e6359e1b7a7d413b069947332464792" => :high_sierra
    sha256 "b050ef7399b75ce62c3894017d8db251f815180dea1a9081a18dfa9a29e883e6" => :sierra
    sha256 "1a44245d15fe570ac53fa8ec18cd4bce345ee8c5539dd18fd09376fb90402c12" => :el_capitan
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
