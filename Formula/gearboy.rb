class Gearboy < Formula
  desc "Nintendo Game Boy (Color) emulator"
  homepage "https://github.com/drhelius/Gearboy"
  url "https://github.com/drhelius/Gearboy/archive/gearboy-2.3.1.tar.gz"
  sha256 "5182f74b7d4a76ee3a995968149e8f2b07841225b30193537ffda17dfd6feb01"
  head "https://github.com/drhelius/Gearboy.git"

  bottle do
    cellar :any
    sha256 "3f25391fa9689c7d1c53988a3bb064082b9ad400fb73bb1f3e923ef1310131ff" => :sierra
    sha256 "7df8075dee5224be99ad9ed3a1d8244b198c5837282092959badc5e9a6b7ec3e" => :el_capitan
    sha256 "c3ca114a29526d2908c11500b91f138a8a45f2b5df09b955668c39bdc25588a8" => :yosemite
  end

  depends_on "qt5"
  depends_on "sdl2"

  def install
    cd "platforms/macosx/Gearboy" do
      inreplace "Gearboy.pro" do |s|
        s.gsub! "/usr/local/include", Formula["sdl2"].include
        s.gsub! "/usr/local/lib", Formula["sdl2"].lib
      end
      system "#{Formula["qt5"].bin}/qmake", "PREFIX=#{prefix}", "CONFIG+=c++11"
      system "make"
      prefix.install "Gearboy.app"
      bin.write_exec_script "#{prefix}/Gearboy.app/Contents/MacOS/Gearboy"
    end
  end
end
