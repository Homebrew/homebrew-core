class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.54/frotz-2.54.tar.bz2"
  sha256 "756d7e11370c9c8e61573e350e2a5071e77fd2781be74c107bd432f817f3abc7"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/DavidGriffith/frotz.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "c96fca92b26db27a63e7af61f8ebfbe6c17e0735208de53417ce04f8affb1233"
    sha256 arm64_sonoma:   "9268c52d9e973184f11ef416876c6c4363cb583437fd2fdadd31e8f54a916e85"
    sha256 arm64_ventura:  "6eb9830313b69d067df65c9e62af464f8126311e35169159a74699c0ae8e4886"
    sha256 arm64_monterey: "8f3a750df4256314233253f180352abbe52636744d5bf48675d0358108644f63"
    sha256 arm64_big_sur:  "2042388f4f26618cbd7e41b5b39ef84be6da3fb4242127ed8c0694f67e10ee0f"
    sha256 sonoma:         "900180b9242da1ba00d22ca6f5338791d7f393d3ca7476f616641c40a3ec94ef"
    sha256 ventura:        "55d904bd4171290616fb0138a178e000ce592d02601d412f3f82c3ed5a502ca7"
    sha256 monterey:       "d682adea94ffdcb59065b589f781106ae753dcf04253b3e69a5e5df672a5553a"
    sha256 big_sur:        "f2ba195e9b744fb2a1d846f365603956b0261bfff8b97c07558fc2fc46b9a750"
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
