class Gearboy < Formula
  desc "Nintendo Game Boy (Color) emulator"
  homepage "https://github.com/drhelius/Gearboy"
  url "https://github.com/drhelius/Gearboy/archive/gearboy-2.3.1.tar.gz"
  sha256 "a1976a82f57d14e625339b50f11cd53da7c6ac1d92ececc4d2b5d163fba4a0ec"
  revision 1
  head "https://github.com/drhelius/Gearboy.git"

  bottle do
    cellar :any
    sha256 "cbb37a8ffbb9649763f36f75236c1f8f2b4001a16c1efc56af7069247a0408cb" => :mojave
    sha256 "1d670f7aa0fabb668cdd96c5f3ef369f96f791e70586191e23ee244ffc024bfb" => :high_sierra
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
