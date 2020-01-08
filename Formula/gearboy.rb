class Gearboy < Formula
  desc "Nintendo Game Boy (Color) emulator"
  homepage "https://github.com/drhelius/Gearboy"
  url "https://github.com/drhelius/Gearboy/archive/gearboy-2.7.0.tar.gz"
  sha256 "e422b8f080ed8decca6386c30e800f19f526d6cac953efce709e5c4f57aa4650"
  head "https://github.com/drhelius/Gearboy.git"

  bottle do
    cellar :any
    sha256 "8dfc995898994e6f66bb2f49023efd265878c3b55c825946ae65a50ab8f1a54a" => :catalina
    sha256 "b92c7577a7287232e161ba437b22c8764be7af8925a19797af63926f8527210c" => :mojave
    sha256 "b92c7577a7287232e161ba437b22c8764be7af8925a19797af63926f8527210c" => :high_sierra
    sha256 "cf8ee78a09a077f9cb37a6dd636882f3732eb2fbab911a47ad77ecf2a9272775" => :sierra
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
