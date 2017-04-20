class Gearsystem < Formula
  desc "Sega Master System / Game Gear emulator"
  homepage "https://github.com/drhelius/Gearsystem"
  url "https://github.com/drhelius/Gearsystem/archive/gearsystem-2.2.tar.gz"
  sha256 "58004ae6cc7497d466213d2b7f00f2f1abbbd2ea900de228e2f392ceb505984a"
  revision 1
  head "https://github.com/drhelius/Gearsystem.git"

  bottle do
    cellar :any
    sha256 "579a1d3668570bec0a4ce146209de78017cc217502fe0ef554a7fb2d3a02276f" => :sierra
    sha256 "d0bc5f5a1612ebc7c8c7f87683de9b0b9b18ac4613d1ee86a9c8492e313e49bb" => :el_capitan
    sha256 "f1ec02f10552f11a9b134eed2dc6263c625b6af8582a05fdd5ef697032dbeeb1" => :yosemite
  end

  depends_on "qt"
  depends_on "sdl2"

  def install
    cd "platforms/macosx/Gearsystem" do
      inreplace "Gearsystem.pro" do |s|
        s.gsub! "/usr/local/include", Formula["sdl2"].include.to_s
        s.gsub! "/usr/local/lib", Formula["sdl2"].lib.to_s
      end
      system "#{Formula["qt"].bin}/qmake", "PREFIX=#{prefix}", "CONFIG+=c++11"
      system "make"
      prefix.install "Gearsystem.app"
      bin.write_exec_script "#{prefix}/Gearsystem.app/Contents/MacOS/Gearsystem"
    end
  end
end
