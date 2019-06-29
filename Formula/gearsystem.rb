class Gearsystem < Formula
  desc "Sega Master System / Game Gear / SG-1000 emulator"
  homepage "https://github.com/drhelius/Gearsystem"
  url "https://github.com/drhelius/Gearsystem/archive/gearsystem-2.6.1.tar.gz"
  sha256 "d7b0116e1a1cf6780bec4279e699dfbe9c4dd8d789f504aff1057b9fab079f47"
  head "https://github.com/drhelius/Gearsystem.git"

  bottle do
    cellar :any
    sha256 "1e9bb0e7b896655279f33c7adbca4566d505eb56c85f11e2bf67bbc3a2e8e2a4" => :mojave
    sha256 "1e9bb0e7b896655279f33c7adbca4566d505eb56c85f11e2bf67bbc3a2e8e2a4" => :high_sierra
    sha256 "d294247a854a2517fdbd02b23845b1be9e01a8b9b650da8a2c632034c5319b5b" => :sierra
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

  test do
    assert_match "GEARSYSTEM", shell_output("#{bin}/gearsystem -v")
  end
end
