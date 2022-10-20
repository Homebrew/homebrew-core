class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.54/frotz-2.54.tar.bz2"
  sha256 "bdf9131e6de49108c9f032200cea3cb4011e5ca0c9fbdbf5b0c05f7c56c81395"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/DavidGriffith/frotz.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a0c7658d7b137bea28fdb1b1f577d91c103158c31d30082f8bfbb352c6d72edb"
    sha256 arm64_big_sur:  "81e96f649f4c6b2f2d530effe32d1d5ab48a39c9aa47891b715062f1b768c565"
    sha256 monterey:       "0af910a56a445405c751aafb5c63df26b0ff4d65e254dd34f832bac4d16ccbe5"
    sha256 big_sur:        "50c1afd7e1de0f785f7a6a6b0587f5a1a6be7738131c9506d848e81a59d7cc72"
    sha256 catalina:       "300f82c7b6bf644a6883519eadc1e71d2463f5a8490fdf3b5f5ca3f4202d7e1e"
    sha256 x86_64_linux:   "43dbed2c89d4671dbe3a9469b3981297a5ef02e53332daa6fb7757eb32b3f875"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libao"
  depends_on "libmodplug"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "ncurses"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  resource("testdata") do
    url "https://gitlab.com/DavidGriffith/frotz/-/raw/2.53/src/test/etude/etude.z5"
    sha256 "bfa2ef69f2f5ce3796b96f9b073676902e971aedb3ba690b8835bb1fb0daface"
  end

  def install
    args = %W[PREFIX=#{prefix} MANDIR=#{man} SYSCONFDIR=#{etc} ITALIC=]
    targets = %w[frotz dumb sdl]
    targets.each do |target|
      system "make", target, *args
    end
    ENV.deparallelize # install has race condition
    targets.each do |target|
      system "make", "install_#{target}", *args
    end
  end

  test do
    resource("testdata").stage do
      assert_match "TerpEtude", pipe_output("#{bin}/dfrotz etude.z5", ".")
    end
    assert_match "FROTZ", shell_output("#{bin}/frotz -v").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz -v").strip
  end
end
