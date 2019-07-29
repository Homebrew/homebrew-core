class Gearsystem < Formula
  desc "Sega Master System / Game Gear / SG-1000 emulator"
  homepage "https://github.com/drhelius/Gearsystem"
  url "https://github.com/drhelius/Gearsystem/archive/gearsystem-2.6.1.tar.gz"
  sha256 "d7b0116e1a1cf6780bec4279e699dfbe9c4dd8d789f504aff1057b9fab079f47"
  head "https://github.com/drhelius/Gearsystem.git"

  bottle do
    cellar :any
    sha256 "0b54b3c432835b541b73c896cb654a0f83a6c1e8c6189f069a767ccec26413d9" => :mojave
    sha256 "7f2091b774263ebe599b8921e97af3d8cb1b5e1a8b899d8c1a335c9d3d5a73aa" => :high_sierra
    sha256 "9a8e8a8172a84416495b48f263582db3a10497db915b371ead261a0a94168839" => :sierra
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
