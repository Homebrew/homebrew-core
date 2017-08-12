class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "http://mednafen.fobby.net/"
  url "https://mednafen.github.io/releases/files/mednafen-0.9.46.tar.xz"
  sha256 "674faf42bdb0ad5649aea65da266b0be3428995caaa7be183fc6d3ed7732467a"

  bottle do
    sha256 "32ef14ae5ba87931383495e770c21121d26e119684ce238a3f0ee35244f13449" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
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
    cmd = "#{bin}/mednafen -dump_modules_def M >/dev/null || head -n 1 M"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
