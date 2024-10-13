class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.49.tar.xz"
  sha256 "65bbec0ede9e6bcf62ac647b0c706485beb2bdd5db70ca8d60103f32f162cf29"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "9c977e38aafafb5fed630407adda4d46493e19e48fa5658979c4e6a687e64500"
    sha256 arm64_sonoma:   "a77a6d24bf2507a9059e103ef4f3c9bbc0161c542a12e0e366e15cf8b0c2bd25"
    sha256 arm64_ventura:  "15989335a5bc1062e17991a3a1db21beaeb884f6a40a019e3858ba44ccd844d1"
    sha256 arm64_monterey: "d6c9bf0666b53074ecb94a3ba567768bd4de62800896e4f9adccf2e818bdb45f"
    sha256 arm64_big_sur:  "0e141cf84da309476a6f32e93b378fb1b6ed69611aef8e801f4686f4dd8cf488"
    sha256 sonoma:         "029393700d3b2d588df2d80bda58aabdb70c7b56c0f63c90be70765a738c57e3"
    sha256 ventura:        "a6af63f5f197e00bd933ae8fff37ffdb957dd67c0337dcdfe8d48762d2774561"
    sha256 monterey:       "a54816a8a15927f3fad83fe079e3fe78dec18f2f7556483a7ce51882cae0d3fa"
    sha256 big_sur:        "8711f7bddb05dfcdb2c8b8060efda8e03b0595dac98dcdb0c33781ecc0f20f44"
    sha256 x86_64_linux:   "08a6994f6f47fbfd0f1ea6d947f840dd9e110ecbdcbd8555041ba002e27a8ca9"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre2"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  fails_with :clang do
    build 1300
    cause "Requires C++20"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1300)

    system "meson", "setup", "build", "-Dcolors=false", "-Dnls=enabled", "-Dregex=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Key configuration screen", shell_output("#{bin}/ncmpc --dump-keys")
    assert_match version.to_s, shell_output("#{bin}/ncmpc --version")
  end
end
