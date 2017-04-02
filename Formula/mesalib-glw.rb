class MesalibGlw < Formula
  desc "Open-source implementation of the OpenGL specification"
  homepage "https://www.mesa3d.org"
  url "https://downloads.sourceforge.net/project/mesa3d/MesaLib/7.2/MesaLib-7.2.tar.gz"
  sha256 "a7b7cc8201006685184e7348c47cb76aecf71be81475c71c35e3f5fe9de909c6"

  bottle do
    cellar :any
    sha256 "270fab4437a38d2d78d7789b2dd34b04e9c8a392975af41440aa14138bc31104" => :sierra
    sha256 "40caa5087e3b8b31b02c9ee7ec00f4eca3cdd4b35eec1fea0ce0ecd64a32689a" => :el_capitan
    sha256 "d700939e346f00e21a71e273895ff61d6984924d85cf41de461fb6674e326f8e" => :yosemite
  end

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-driver=xlib",
                          "--disable-gl-osmesa",
                          "--disable-glu",
                          "--disable-glut"

    inreplace "configs/autoconf" do |s|
      s.gsub! /.so/, ".dylib"
      s.gsub! /SRC_DIRS = mesa glw/, "SRC_DIRS = glw"
      s.gsub! %r{-L\$\(TOP\)/\$\(LIB_DIR\)}, "-L#{MacOS::X11.lib}"
    end

    inreplace "src/glw/Makefile", %r{-I\$\(TOP\)/include }, ""

    system "make"

    (include+"GL").mkpath
    (include+"GL").install Dir["src/glw/*.h"]
    lib.install Dir["lib/*"]
  end
end
