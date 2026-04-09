class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.55/frotz-2.55.tar.bz2"
  sha256 "235a8606aa1e654aa5a5a41b5c7b5ae1e934aab30fb2e2b18e2e35a4eafcd745"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/DavidGriffith/frotz.git", branch: "master"

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "13e6781a5e0e185bb4bb73634f55d01ae38a55127b20f0f6eb0e88ff13bef27a"
    sha256               arm64_sequoia: "c6318bbdd29d11d3e152f706fb323f0d21a1e2c4c5e34e018b9471a69fcbdc84"
    sha256               arm64_sonoma:  "5e33bf2af7642a97850c3c2c721e57b7c7ab5fa1f41af67252bba0ddd9f1b9a5"
    sha256 cellar: :any, sonoma:        "7a026e6bed92668413cc87b1f258bcae2b5148eb0047870213888297321a4c9c"
    sha256               arm64_linux:   "aa9a5806184fe47d3fefec645caf64db935ff3f85bb4254e2b8ed9ebfb9c4c4a"
    sha256               x86_64_linux:  "40aecc84a29e2a331e298a2d1a1640c6b5efc63a56960799b04c75ddcf7c169a"
  end

  depends_on "pkgconf" => :build
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # fix SDL interface build failure
  patch do
    url "https://gitlab.com/DavidGriffith/frotz/-/commit/52be64afc92a6ea0a982ff83205a67cbfb94b619.diff"
    sha256 "d9105caf79c436d98fa80b8091b1dd05de88c8c7f26c2a688133879b7dfa3477"
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
    resource "testdata" do
      url "https://gitlab.com/DavidGriffith/frotz/-/raw/2.53/src/test/etude/etude.z5"
      sha256 "bfa2ef69f2f5ce3796b96f9b073676902e971aedb3ba690b8835bb1fb0daface"
    end

    resource("testdata").stage do
      assert_match "TerpEtude", pipe_output("#{bin}/dfrotz etude.z5", ".")
    end
    assert_match "FROTZ", shell_output("#{bin}/frotz -v").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz -v").strip
  end
end
