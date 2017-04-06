class Gearboy < Formula
  desc "Nintendo Game Boy (Color) emulator"
  homepage "https://github.com/drhelius/Gearboy"
  url "https://github.com/drhelius/Gearboy/archive/gearboy-2.3.1.tar.gz"
  sha256 "5182f74b7d4a76ee3a995968149e8f2b07841225b30193537ffda17dfd6feb01"
  revision 1
  head "https://github.com/drhelius/Gearboy.git"

  bottle do
    cellar :any
    sha256 "2c6a9f3e619bbb3a334ede4c3ab8cdfbb930b14536285427c4ec42e571a54755" => :sierra
    sha256 "2c6a9f3e619bbb3a334ede4c3ab8cdfbb930b14536285427c4ec42e571a54755" => :el_capitan
    sha256 "1e0697e7131d6a8b273055153c60fa4d596e23fc916a6a7bc85c47bc2ac02a5f" => :yosemite
  end

  depends_on "qt"
  depends_on "sdl2"

  def install
    cd "platforms/macosx/Gearboy" do
      inreplace "Gearboy.pro" do |s|
        s.gsub! "/usr/local/include", Formula["sdl2"].include
        s.gsub! "/usr/local/lib", Formula["sdl2"].lib
      end
      system "#{Formula["qt"].bin}/qmake", "PREFIX=#{prefix}", "CONFIG+=c++11"
      system "make"
      prefix.install "Gearboy.app"
      bin.write_exec_script "#{prefix}/Gearboy.app/Contents/MacOS/Gearboy"
    end
  end
end
