class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.53.tar.xz"
  sha256 "92c68bb9bf294d48209587b19df9005db7247e9c38d7e4fb74f8586e6f23c56f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7c181f669486f1d0d91c10960d9205abf5facc063ba8d2f4dd4f9129a815207a"
    sha256 arm64_sequoia: "af8197235579cf6bc71b5ccb33841adcea1f58a26e54ca502c332b79b163c242"
    sha256 arm64_sonoma:  "92be643c8a15acdcfccfc80afb71b36ad6ff6c6d514129eb12ed4f7a5e5d3507"
    sha256 sonoma:        "732a7f423bb35e20705c437f840a2152469be96389e0f9d26c8a01c4c235265a"
    sha256 arm64_linux:   "ef607fd9ac877b7577a73e2bbd4ddce46347ae47125400da5e6d0c0a046c06b4"
    sha256 x86_64_linux:  "de69ab5dfd2f9a9142854e6145e44c832bc953e26d52251e7aaa4376737ab5fb"
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
