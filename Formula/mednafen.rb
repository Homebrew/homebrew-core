class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.21.2.tar.xz"
  sha256 "528b7ad6976182c451f7e7852f79fcc8e81e29005823f9c9bed816914bfd6da2"

  bottle do
    sha256 "ba2295e65433001d24d1001638aeb86565467d6ca690105c9382c4573766c42c" => :high_sierra
    sha256 "88644723477cfc5087df7b8d7f386fd4c85b70fb7d15616277de742ea3921ac6" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libsndfile"
  depends_on :macos => :sierra # needs clock_gettime
  depends_on "gettext"

  def install
    # Fix run-time crash "Assertion failed: (x == TestLLVM15470_Counter), function
    # TestLLVM15470_Sub2, file tests.cpp, line 643."
    # LLVM miscompiles some loop code with optimization
    # https://llvm.org/bugs/show_bug.cgi?id=15470
    ENV.O2

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
