class Gearsystem < Formula
  desc "Sega Master System / Game Gear emulator"
  homepage "https://github.com/drhelius/Gearsystem"
  url "https://github.com/drhelius/Gearsystem/archive/gearsystem-2.2.tar.gz"
  sha256 "58004ae6cc7497d466213d2b7f00f2f1abbbd2ea900de228e2f392ceb505984a"
  revision 1
  head "https://github.com/drhelius/Gearsystem.git"

  bottle do
    cellar :any
    sha256 "8c45e772d85b891912f6b013b9804264da90ab74447b31d6a94fd3fcbcb34717" => :sierra
    sha256 "8c45e772d85b891912f6b013b9804264da90ab74447b31d6a94fd3fcbcb34717" => :el_capitan
    sha256 "65b352779cf002a0bdffaed489887e24d3b397d736aeeaa4f09ac2fc653c7832" => :yosemite
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
