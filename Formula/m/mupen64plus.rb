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
    sha256 arm64_tahoe:   "bcdd3173e040bf26c85fb1ede2377ebffaa0ce143720c5f2d200159cb52d3708"
    sha256 arm64_sequoia: "fa76319a48aa3bc5d5997f8c5108156a8501c110bc7e02a3a69d86065cd28264"
    sha256 arm64_sonoma:  "5005db0835711d42c5d6c457795e4b6374e974568f380fb381d440266dbdd5b1"
    sha256 arm64_ventura: "5a9308e8d1a6356bbef3f5f6009fb06c1d190d59fd3e85565c4f9e1123cf3ff1"
    sha256 sonoma:        "26e73f4712a1bf42221a86efe322010a2f9b521f58c9b24611881522967b790f"
    sha256 ventura:       "788e3150ef2a190f730edd401a47c46b548f978994fdcd5497f2ed7ec1db433c"
    sha256 arm64_linux:   "c97d64ce1bfe545d8d9e25100ab24dd6a75c660683473db88417db2015ccecda"
    sha256 x86_64_linux:  "6b1e569e22ff2c8f5ef5b343f93a684b6a866e12df7b5e1dd615b79c4e361b75"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "vulkan-loader"
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
    # Disable test in Linux and Tahoe CI because it hangs because a display is not available.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    return if OS.mac? && MacOS.version == :tahoe && ENV["HOMEBREW_GITHUB_ACTIONS"]

    resource "rom" do
      url "https://github.com/mupen64plus/mupen64plus-rom/raw/76ef14c876ed036284154444c7bdc29d19381acc/m64p_test_rom.v64"
      sha256 "b5fe9d650a67091c97838386f5102ad94c79232240f9c5bcc72334097d76224c"
    end

    resource("rom").stage do
      system bin/"mupen64plus", "--testshots", "1", "m64p_test_rom.v64"
    end
  end
end
