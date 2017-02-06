class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "http://mednafen.fobby.net/"
  url "https://mednafen.github.io/releases/files/mednafen-0.9.41.tar.xz"
  sha256 "74736b9b52a7ba6270b67ae8e6c876a887e0e26a00a7d96bdd49af17992aac47"

  bottle do
    sha256 "9959b1e649d1557b5e3a1e9f0637fcc043caa0bd45ce6888785647dbee9495cf" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "libsndfile"
  depends_on "gettext"

  needs :cxx11

  fails_with :clang do
    build 800
    cause <<-EOS.undent
      LLVM miscompiles some loop code with optimization
      https://llvm.org/bugs/show_bug.cgi?id=15470
      EOS
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mednafen -dump_modules_def M >/dev/null || head -n 1 M").chomp
  end
end
