class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://github.com/FrodeSolheim/fs-uae/releases/download/v3.2.35/fs-uae-3.2.35.tar.xz"
  sha256 "f3d3cb8d3df34b0b0125c45a5a3e187ff71050be5dc8455cc4505c0380269117"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "769d5c85cb160bbd2521c0000f754cd09a722ac8479d75adb3d27590aaf8e33e"
    sha256 cellar: :any,                 arm64_sequoia: "f7e449b37471f4581edf74125ab3eb5fa63c6748ea69234fb71f1f3403e24053"
    sha256 cellar: :any,                 arm64_sonoma:  "6bb679b91db7baf47a786aa26f0b70f8326fe909e43f691a61dd518cb9666fa5"
    sha256 cellar: :any,                 sonoma:        "6a14ab40de477077a5c17fed2cb17cbb20e441a0d378214e0d53823ade1c520a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4786d5f639c34e2776d6089d9a19274890ae57ff3b615a5a52cd738212965a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531c484788d6a7ac1f7ffb1ee8786d1f0f992f4a2a0a8a5ef7e276f359395125"
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "freetype"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libx11"
    depends_on "openal-soft"
  end

  def install
    system "./bootstrap" if build.head?

    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-c++11-narrowing" if DevelopmentTools.clang_build_version >= 1400

    system "./configure", "--disable-silent-rules", *std_configure_args
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unnecessary files
    rm_r(share/"applications")
    rm_r(share/"icons")
    rm_r(share/"mime")
  end

  test do
    # fs-uae is a GUI application
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
