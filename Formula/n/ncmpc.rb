class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.55.tar.xz"
  sha256 "9b332932306e210f28b27f65b368a1ebf9270410c2ea9ac0d620d46f2a5379a8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "00adf3a528481dd0ee5b1832e6d74b85e9b4fd481c361c3f2891dd8195f2e879"
    sha256 arm64_golden_gate: "98dbae46af76ebbdd9cb07ec1d18920aceae7e74a1602f0c78601d4470734790"
    sha256 arm64_tahoe:       "380d5542e059f7207c9bb1f01561514940261aa200d243fd16aee9b708cefb16"
    sha256 arm64_sequoia:     "3fc654fdaa68ef86af67e22acb40369111f73cf2bf30c14a5a8748b19e50985b"
    sha256 arm64_linux:       "5119fe178e3a48f5a3a9715d741a67fa62b4004bf844b7683cc57dc1669a5d71"
    sha256 x86_64_linux:      "021538cdfc5769bc905cfd7d0dacf4e03b20059d9fce250e2f3dc8064e5ecdaa"
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
