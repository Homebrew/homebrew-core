class Np2 < Formula
  desc "Neko Project 2: PC-9801 emulator"
  homepage "https://www.yui.ne.jp/np2/"
  url "http://amethyst.yui.ne.jp/svn/pc98/np2/tags/VER_0_86/", :using => :svn, :revision => "2606"
  head "http://amethyst.yui.ne.jp/svn/pc98/np2/trunk/", :using => :svn

  bottle do
    cellar :any
    sha256 "0d341c9c1da3caccb8c2746e876b578fcdda626cc7d6fe3c071b2a10a2216cb4" => :high_sierra
    sha256 "18f54de6cd5a7b913c9be1af8494cce362d52f94c751c63da9beffcd4f3fc41c" => :sierra
    sha256 "969d59ab9401163f14b9c5830f884f0ff9f4d25f81985472f6a41b5b4debcbff" => :el_capitan
    sha256 "a7340b1deadb9fdb4e117b9d793e695631d7d9a52ae111703e9bc6ea796c290b" => :yosemite
  end

  depends_on :xcode => :build
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    sdl2 = Formula["sdl2"]
    sdl2_ttf = Formula["sdl2_ttf"]

    cd "sdl2/MacOSX" do
      # Use brewed library paths
      inreplace "np2sdl2.xcodeproj/project.pbxproj" do |s|
        s.gsub! "BAF84E4B195AA35E00183062", "//BAF84E4B195AA35E00183062"
        s.gsub! "HEADER_SEARCH_PATHS = (",
                "LIBRARY_SEARCH_PATHS = (\"$(inherited)\", #{sdl2.lib}, #{sdl2_ttf.lib}); " \
                "HEADER_SEARCH_PATHS = (#{sdl2.include}/SDL2, #{sdl2.include}, #{sdl2_ttf.include},"
        s.gsub! "buildSettings = {", 'buildSettings ={ OTHER_LDFLAGS = "-lSDL2 -lSDL2_ttf";'
      end
      # Force to use Japanese TTF font
      inreplace "np2sdl2/compiler.h", "#define RESOURCE_US", ""
      # Always use current working directory
      inreplace "np2sdl2/main.m", "[pstrBundlePath UTF8String]", '"./"'

      xcodebuild "SYMROOT=build"
      bin.install "build/Release/np2sdl2.app/Contents/MacOS/np2sdl2" => "np2"
    end
  end

  def caveats; <<~EOS
    A Japanese TTF file named `default.ttf` should be in the working directory.
  EOS
  end

  test do
    assert_match %r{Usage: #{bin}/np2}, shell_output("#{bin}/np2 -h", 1)
  end
end
