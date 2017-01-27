class MesalibGlw < Formula
  homepage "http://www.mesa3d.org"
  url "https://downloads.sourceforge.net/project/mesa3d/MesaLib/7.2/MesaLib-7.2.tar.gz"
  sha256 "a7b7cc8201006685184e7348c47cb76aecf71be81475c71c35e3f5fe9de909c6"

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

    inreplace "src/glw/Makefile" do |s|
      s.gsub! %r{-I\$\(TOP\)/include }, ""
    end

    system "make"

    (include+"GL").mkpath
    (include+"GL").install Dir["src/glw/*.h"]
    lib.install Dir["lib/*"]
  end
end
