class Opensyobon < Formula
  desc "Parody of Super Mario Bros"
  homepage "https://opensyobon.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/opensyobon/src/SyobonAction_rc2_src.tar.gz"
  version "1.0rc2"
  sha256 "a61a621de7e4603be047e8666c0376892200f2876c244fb2adc9e4afebc79728"
  revision 1

  bottle do
    cellar :any
    sha256 "8533133b6e178a6d24e39e3975ba9f539d135ce74deb8a015f511d19e39271f2" => :high_sierra
    sha256 "215b9473caaf9ada21e1cdf394845f33170b5bfdf046be68b3c57e4b97df18fe" => :sierra
    sha256 "85febfd924159a3f8913765a48d5c9d507b1917545b6c1f35114180eeff5c521" => :el_capitan
    sha256 "18494006fa2ef4c2d49f5a753d23909999db49f8fb58f405fc06f588fa973633" => :yosemite
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
    (bin/"SyobonAction").write <<~EOS
      #!/bin/sh
      cd "#{pkgshare}" && exec ./SyobonAction "$@"
      EOS
  end

  test do
    assert_predicate pkgshare/"SyobonAction", :executable?
  end
end
