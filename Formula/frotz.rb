class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.52/frotz-2.52.tar.bz2"
  sha256 "7e81789d7958ef42426a3067855cb3dc8eda04a5aa80d2803e32dd9282452932"
  license "GPL-2.0"
  head "https://gitlab.com/DavidGriffith/frotz.git"

  bottle do
    sha256 "9cf846f08395d4be4d09c14eee622ee583e74cce4551175dead61a2cd71b2110" => :big_sur
    sha256 "221374559017427b4cce070f84cd46cc7f3e8aae5e8fa035c6bcec392f4a6f3d" => :arm64_big_sur
    sha256 "1ed32dda7751fc0fe562cded7e618b7e5d9717e0342520d001f21d2094aaf5e8" => :catalina
    sha256 "c71a655ef6d2906e9d094c6383d0a5a2f69d8c6e1c52352159a1a639c9003cea" => :mojave
    sha256 "aa55fbacadbb897b30ec469d0f652ad4674b1c844072d5e47f02d152d3da6b9c" => :high_sierra
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
    url "https://gitlab.com/DavidGriffith/frotz/-/raw/master/src/test/etude/etude.z5"
    sha256 "bfa2ef69f2f5ce3796b96f9b073676902e971aedb3ba690b8835bb1fb0daface"
  end

  def install
    args = %W[PREFIX=#{prefix} MANDIR=#{man} SYSCONFDIR=#{etc}]
    system "make", "all", *args
    ENV.deparallelize # install has race condition
    system "make", "install_all", *args
  end

  test do
    resource("testdata").stage do
      assert_match "TerpEtude", shell_output("echo \".\" | #{bin}/dfrotz etude.z5")
    end
    assert_match "FROTZ", shell_output("#{bin}/frotz -v").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz -v").strip
  end
end
