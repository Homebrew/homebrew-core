class Idris < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.3.tar.gz"
  sha256 "ad693614cc61a92bf51a33f5dc74f90b2eba91fd89064ec0580525e220556113"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    rebuild 1
    sha256 "cbae5a36e3912cbefc10acc8f6295bf313b8532bbe6eb2a53b2427d68772952e" => :big_sur
    sha256 "df17f5104195ea42a489ef6392a3c4ad5f94de7442f38352cdbef31d4abc3799" => :catalina
    sha256 "ba0945d4c86053b525067f4f1fa8781d72903b4f40522edd7b0e15fd62e7ba4a" => :mojave
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc@8.8"
  depends_on "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "--storedir=#{libexec}", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

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
