require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.1.0.tar.gz"
  sha256 "74d4a4fdfb4cb8cf86d3ea0487044fc58c65565f29a46ef1fc1a635fefab7df0"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "859d249ba1548d995d77b576294aad39d390ae7c68b6db5e3488b51cc0a3a46d" => :sierra
    sha256 "3dab50b441322e6242e8ee2509ab5a52354d353c420a94545736a1a4cc2dc437" => :el_capitan
    sha256 "6a3a3573d721b3351c669b3c78a2158c12e1ec389d7e91c9bc0f218f183d3f5b" => :yosemite
  end

  depends_on "ghc@8.0" => :build
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
