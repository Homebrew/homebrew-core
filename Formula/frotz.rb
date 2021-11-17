class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.53/frotz-2.53.tar.bz2"
  sha256 "8da558828dd74d6d6ee30483bb32276ef918b8b72b7f6e89b4f7cb27e7abf58b"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/DavidGriffith/frotz.git"

  bottle do
    sha256 arm64_monterey: "4b52b494b83a2d60e856a5663e4b84bb2e20d0479ff4781e77a1148dcdf155b3"
    sha256 arm64_big_sur:  "a51e453e14b7bd58a0a90169ae238f04650b8ffd1f2178f2245afc09127ff2cd"
    sha256 monterey:       "919b65bd87568ee0060f6ae9668293f95df602e72185d531af6dd9112b9cc901"
    sha256 big_sur:        "36f0a6760575194191ee9035e479357451ffeeef291fb4697deb61c19524b2ad"
    sha256 catalina:       "d84c37e5af40ea04a4a23569605d2648480abf394bddc9a1a8e4d75988c73e24"
    sha256 mojave:         "44612a1e36afeb27bbec0ada1dd7474e20d8f2d8580d32791dd98c2ea862ff0c"
    sha256 x86_64_linux:   "4eb6b4247b3e7b99e9ce2646f171c312d4af4b961909e33ab394957ed3fa6112"
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
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "ncurses"
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
