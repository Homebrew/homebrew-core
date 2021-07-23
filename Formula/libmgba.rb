class Libmgba < Formula
  desc "Game Boy Advance emulator library"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.9.2.tar.gz"
  sha256 "29ca22ebc56b26a4e7224efbb5fa12c9c006563d41990afb0874d048db76add4"
  license "MPL-2.0"
  head "https://github.com/mgba-emu/mgba.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DDISABLE_FRONTENDS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      This formula only installs libmgba.

      mGBA.app can be downloaded directly from the website:
        https://mgba.io/

      Alternatively, install with Homebrew Cask:
        brew install --cask mgba
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mgba/core/core.h>
      #include <mgba/gba/core.h>
      int main() {
        struct mCore* core = GBACoreCreate();
        core->init(core);
        core->deinit(core);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmgba", "-o", "test"
    system "./test"
  end
end
