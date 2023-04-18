class Idris < Formula
  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.3.4.tar.gz"
  sha256 "7289f5e2501b7a543d81035252ca9714003f834f58b558f45a16427a3c926c0f"
  license "BSD-3-Clause"
  head "https://github.com/idris-lang/Idris-dev.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_monterey: "9150e74cf8c82c309d033dca9040789ca64994c0c761b192c44a067741f2418a"
    sha256 arm64_big_sur:  "f2769fc400bf64efe5acc9597580941ac41e9c5b5a0f06e2ac5102e5700d9bd6"
    sha256 ventura:        "64efdce9b9e7028223996595ddfbbdec7938a59109c68f997dd5f686239d5b4f"
    sha256 monterey:       "71135b6676bee0321a1d1725cf546385a6019abca0dac7503f76683d3cc5cf3c"
    sha256 big_sur:        "750f4c74007ad366853262c6617321443e2ae3cf20e404ca825b5b9ca13d3b19"
    sha256 x86_64_linux:   "864094063e7ad6971b4e121b6b4debb38fecaa338be1b829d6c8e626f8b0f8b9"
  end

  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "ghc@8.10"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
