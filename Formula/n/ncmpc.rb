class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.54.tar.xz"
  sha256 "f678e6c600200af4c5d36174de4e1e82e423962c41b6f52844a25d6d1ec4cb11"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "01f27e1ff0a2f605890c0173ad0b85a898c8d6a51596d5be1dd2e89fc485d9c3"
    sha256 arm64_sequoia: "945ee2a8f5973177f18a5b99802874d267edb9babc287b2b5620d3d24fc6efb0"
    sha256 arm64_sonoma:  "98abc7f9c86e2b88b2f0bc3b31acfe469819d2239206630084fa2baebba5f522"
    sha256 sonoma:        "b29421ee05719bc3ff95bee08d23a9536a05287d2beef8dcdadb75cfdfe90b28"
    sha256 arm64_linux:   "190d8bd3e1cf22bf5b4dcb3f652aadc20f0f69a010a784a3f30a2adc5ca3974f"
    sha256 x86_64_linux:  "b206451d9cd88eb6487f0483c8bee838331619bc2c5e6eec8b41222ce6132337"
  end

  depends_on "boost" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fmt"
  depends_on "libmpdclient"
  depends_on "pcre2"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1500

    # Fixes: error: use of undeclared identifier 'strcoll_l'
    patch do
      url "https://github.com/MusicPlayerDaemon/ncmpc/commit/af478b5ba2447592c640c5b7f86c47d9a412c639.patch?full_index=1"
      sha256 "193f6c3192ba39974a2f1ef4935c623d58e0614f9978b2e6545c6231fd5ffdb5"
      type :unofficial
      resolves "https://github.com/MusicPlayerDaemon/ncmpc/pull/160"
    end
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    # Apple Clang 16 rejects `constexpr` with `reinterpret_cast` (P2448 needs LLVM 17), e.g. GetSteadyPart()
    ENV.append "CXXFLAGS", "-Wno-invalid-constexpr" if OS.mac? && DevelopmentTools.clang_build_version < 1700

    system "meson", "setup", "build", "-Dcolors=false", "-Dnls=enabled", "-Dregex=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Key configuration screen", shell_output("#{bin}/ncmpc --dump-keys")
    assert_match version.to_s, shell_output("#{bin}/ncmpc --version")
  end
end
