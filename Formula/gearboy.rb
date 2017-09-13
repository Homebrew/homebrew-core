class Gearboy < Formula
  desc "Nintendo Game Boy (Color) emulator"
  homepage "https://github.com/drhelius/Gearboy"
  url "https://github.com/drhelius/Gearboy/archive/gearboy-2.3.1.tar.gz"
  sha256 "5182f74b7d4a76ee3a995968149e8f2b07841225b30193537ffda17dfd6feb01"
  revision 1
  head "https://github.com/drhelius/Gearboy.git"

  bottle do
    cellar :any
    sha256 "91bfab6b8f83e80620d72c40cc1ca4256d7f15910d48d2919a6ba9c152939425" => :sierra
    sha256 "35e8aeca3e1204cfa1fd105634994d94e4c69f86bca4bf791fcd937c9da2ab29" => :el_capitan
    sha256 "2572d0286af3eefda16352a9c74050bc62b76bf91b64be9d74af0c82230df9da" => :yosemite
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
