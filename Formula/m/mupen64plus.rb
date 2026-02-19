class Mupen64plus < Formula
  desc "Cross-platform plugin-based N64 emulator"
  homepage "https://www.mupen64plus.org/"
  url "https://github.com/mupen64plus/mupen64plus-core/releases/download/2.6.0/mupen64plus-bundle-src-2.6.0.tar.gz"
  sha256 "297e17180cd76a7b8ea809d1a1be2c98ed5c7352dc716965a80deb598b21e131"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "73a594a4179e8c405898e24d23a3de66e3476734fe4d6271229a65ad9d94d143"
    sha256 arm64_sequoia: "2ac11668fdeba8ca47b221e7e35fa0a7c1388644144673ea2981dd282214bdd6"
    sha256 arm64_sonoma:  "1ba75f761d4a6c9520ff61d79fe13e08d2d0c72b039f4f40bc8ba35bd1dbcc86"
    sha256 sonoma:        "7af6a82beaa3bcd3f82e86abab6f473836a542f2e6a35daa1795b2ae88e791e4"
    sha256 arm64_linux:   "0b6dc156754e78588093434bd7d0a8729704b3425d3241887ce84d59b986131c"
    sha256 x86_64_linux:  "53ffc3a9f022ab20a782517db83e4b69cd4722e998cfe4ac41d10c49ab2a513a"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  on_linux do
    depends_on "mesa"
    depends_on "vulkan-loader"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # Backport fix to avoid macOS app bundle path
  patch do
    url "https://github.com/mupen64plus/mupen64plus-ui-console/commit/1cab2e6dfe46d5fbc4c23e1e7fbb4502a4e57981.patch?full_index=1"
    sha256 "a6e80f36b65406d31f3611f88e695e5c079db52b6f68daa8eb01307f5447194c"
    directory "source/mupen64plus-ui-console"
  end

  def install
    # Prevent different C++ standard library warning
    if OS.mac?
      inreplace Dir["source/mupen64plus-*/projects/unix/Makefile"],
                /(-mmacosx-version-min)=\d+\.\d+/,
                "\\1=#{MacOS.version}"
    end

    args = ["PREFIX=#{prefix}", "SHAREDIR=#{pkgshare}", "NO_SRC=1", "NO_SPEEX=1", "V=1"]
    args << "USE_GLES=1" if OS.linux?

    system "./m64p_build.sh", *args
    system "./m64p_install.sh", *args
  end

  test do
    # Disable test in Tahoe CI because it hangs because a display is not available.
    return if OS.mac? && MacOS.version == :tahoe && ENV["HOMEBREW_GITHUB_ACTIONS"]

    resource "rom" do
      url "https://github.com/mupen64plus/mupen64plus-rom/raw/76ef14c876ed036284154444c7bdc29d19381acc/m64p_test_rom.v64"
      sha256 "b5fe9d650a67091c97838386f5102ad94c79232240f9c5bcc72334097d76224c"
    end

    resource("rom").stage(testpath)
    system bin/"mupen64plus", "--testshots", "1", "m64p_test_rom.v64"
  end
end
