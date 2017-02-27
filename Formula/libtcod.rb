class Libtcod < Formula
  desc "API for roguelike developpers"
  homepage "http://roguecentral.org/doryen/libtcod/"
  url "https://bitbucket.org/libtcod/libtcod/get/1.5.1.tar.bz2"
  sha256 "290145f760371881bcc6aa3fda256a2927f9210acc3f0a7230c5dfd57d9052d0"

  bottle do
    cellar :any
    sha256 "ccad47287c9a34afcffa48d6b8f469cb729a1133f95f44be0fe7a1506723980f" => :sierra
    sha256 "65cf5860b8325fe352f497ad287303c4a725e623d1a64c45c879463a36603f51" => :el_capitan
    sha256 "de169860f67c2be9d4ed7770f682700b31642030da1b50583b26b53e5e514bfe" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "sdl"

  conflicts_with "libzip", :because => "both install `zip.h` header"

  def install
    # Remove unnecessary X11 check - our SDL doesn't use X11
    inreplace "CMakelists.txt" do |s|
      s.gsub! "find_package(X11 REQUIRED)", ""
      s.gsub! "${X11_INCLUDE_DIRS}", ""
    end

    system "cmake", ".", *std_cmake_args
    system "make"

    # cmake produces an install target, but it installs nothing
    lib.install "src/libtcod.dylib"
    lib.install "src/libtcod-gui.dylib"
    include.install Dir["include/*"]
    # don't yet know what this is for
    libexec.install "data"
  end
end
