class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.21.1.tar.xz"
  sha256 "848136e4b98d5a949d7691f6596564b20d5720e7d766e93deedc7832bbee2a40"

  bottle do
    sha256 "bf8c7892c65f2edebdc14e3afdf342551689078a4d342c48354e6ae0390f728a" => :high_sierra
    sha256 "28d2204ee6d2a149c52f2e3fa5eb93df32ade953f23d55baf7b42a6dc2381c6c" => :sierra
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
