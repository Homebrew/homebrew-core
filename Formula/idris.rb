require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.2.0.tar.gz"
  sha256 "a5160da66cdfb376df0ed87f0abb9dbc7feaa4efe77bcc7f9cc3b97425bc57f7"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "a3cb09de4df1065d058dbe1450b7049291554180c1d7f5e951ac094b1be7233f" => :high_sierra
    sha256 "ebe09791a9d22982c3798a1dee303ebc2984194364186f235782d156160430db" => :sierra
    sha256 "87b951e346e1abd5fb01237b3f88f19c1e31fc5fe15d84144b090acf22c83363" => :el_capitan
    sha256 "324862f1b5b9077a1cc2623766f55026c9e6fc2613d57e2b0c65311afc665f7c" => :yosemite
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
