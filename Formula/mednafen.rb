class Mednafen < Formula
  desc "Multi-system emulator"
  homepage "https://mednafen.github.io/"
  url "https://mednafen.github.io/releases/files/mednafen-1.27.1.tar.xz"
  sha256 "f3a89b2f32f40c3232593808d05e0c21cbdf443688ace04c9c27e4cf4d5955fb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://mednafen.github.io/releases/"
    regex(/href=.*?mednafen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "bb336129af921db2f951e911115094e20b8296051633cc80cd70e8fafbede993"
    sha256 arm64_big_sur:  "89eb1006849d1d949b425d2937a7ca6e00c703a1edae563075dba88ccc817a0c"
    sha256 monterey:       "e79b486c330c248c8e537aa3dfea231b5087de4f75d3db391cce82e144c7cb08"
    sha256 big_sur:        "5d671db565de9ce937475c19880caf88d38faa2b2b8a42888230a0be27f32615"
    sha256 catalina:       "beda51be33761b5b9e9764093e313b567d1b1bcd58aab91a64d3f7a4099d2c93"
    sha256 mojave:         "62500c988c009c14e45f80de2f69d3b9a352946a36888adfe94b4eda14e6fc9f"
    sha256 x86_64_linux:   "9385785347f0e28b221bc0d8dc0a6afbcab5eeda7664bbfc749cbafc8a8d75b6"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libsndfile"
  depends_on macos: :sierra # needs clock_gettime
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    # Test fails on headless CI: Could not initialize SDL: No available video device
    on_linux do
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    cmd = "#{bin}/mednafen | head -n1 | grep -o '[0-9].*'"
    assert_equal version.to_s, shell_output(cmd).chomp
  end
end
