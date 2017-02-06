class Opensyobon < Formula
  desc "Parody of Super Mario Bros"
  homepage "http://opensyobon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/opensyobon/src/SyobonAction_rc2_src.tar.gz"
  version "1.0rc2"
  sha256 "a61a621de7e4603be047e8666c0376892200f2876c244fb2adc9e4afebc79728"
  revision 1

  bottle do
    cellar :any
    sha256 "bedb519dede9fa3faef539cddf43e73c9710a2a5a1a9db39d8ee3035a04d12e9" => :el_capitan
    sha256 "95aa58fd64ca54d11fb8b271a1aaae36c28ac9e861cc70af727dbdcd9d345de2" => :yosemite
    sha256 "c5711cafbb9b01051625c1c6c81091dda4ffa4143c26872d297aed4eb84d6d39" => :mavericks
  end

  depends_on "sdl"
  depends_on "sdl_gfx"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"

  resource "data" do
    url "https://downloads.sourceforge.net/project/opensyobon/src/SyobonAction_rc2_data.tar.gz"
    sha256 "073be7634600df28909701fa132c8e474de1ff9647bf05816f80416be3bcaa9f"
  end

  def install
    inreplace "Makefile", "gcc", ENV.cxx
    inreplace "DxLib.cpp", /(setlocale)/, '//\1'
    system "make"
    pkgshare.install "SyobonAction"
    pkgshare.install resource("data")
    (bin/"SyobonAction").write <<-EOS.undent
      #!/bin/sh
      cd "#{pkgshare}" && exec ./SyobonAction "$@"
      EOS
  end

  test do
    File.executable? "#{pkgshare}/SyobonAction"
  end
end
