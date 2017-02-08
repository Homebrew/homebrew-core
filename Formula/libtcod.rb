class Libtcod < Formula
  desc "API for roguelike developpers"
  homepage "http://roguecentral.org/doryen/libtcod/"
  url "https://bitbucket.org/libtcod/libtcod/get/1.5.1.tar.bz2"
  sha256 "290145f760371881bcc6aa3fda256a2927f9210acc3f0a7230c5dfd57d9052d0"

  depends_on "cmake" => :build
  depends_on "sdl"

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
