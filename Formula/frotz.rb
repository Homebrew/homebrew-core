class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.54/frotz-2.54.tar.bz2"
  sha256 "bdf9131e6de49108c9f032200cea3cb4011e5ca0c9fbdbf5b0c05f7c56c81395"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/DavidGriffith/frotz.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "549071e77d620452882d0de93e6f9ea8c1626841f5061c78a3e61a611bbb12ce"
    sha256 arm64_big_sur:  "b5508362bd7be4cbebbd2d927cad4a22454122534d03908c60d2fa5c28be89c7"
    sha256 monterey:       "4eeaf3343a939186a6151d565abf4c08416b2759f096e8acdc7466bb474dc454"
    sha256 big_sur:        "21ff203a161a1ef98a86b2cab28e8ec5f1ab15ef1529debff8a69342158851e7"
    sha256 catalina:       "973fe5f8cc67f7679260e4bf6779bbd739990c4cb077415d5e5d6be72add919e"
    sha256 x86_64_linux:   "ea64d973cee2ef29d37d4b975b8d6c522df4b60a0e9b6d632397b078003734a5"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
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
