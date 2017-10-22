class Fifengine < Formula
  desc "multi-platform isometric game engine"
  homepage "http://www.fifengine.net"
  url "https://github.com/fifengine/fifengine/archive/0.4.1.tar.gz"
  sha256 "bae3fc591cc2891f7d1b3a656a5d8ad700ecc2e297ad453bf4f1bcbbf82e8cb2"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on :python
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"
  depends_on "libpng"
  depends_on "tinyxml"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "fifechan"

  def install
    mkdir buildpath/"macbuild" do
      system "cmake", "..", "-Duse-githash=OFF", *std_cmake_args
      python_ver = `python -c "from __future__ import print_function; import sysconfig; print(sysconfig.get_python_version())"`.chomp
      python_platstdlib = `python -c "from __future__ import print_function;import sysconfig; print (sysconfig.get_path('stdlib'))"`.chomp
      inreplace "cmake_install.cmake", python_platstdlib, "#{lib}/python#{python_ver}/"
      File.open("CMakeCache.txt") do |f|
        f.each_line do |cmakecache|
          if cmakecache.start_with? 'PYTHON_LIBRARY:FILEPATH='
            python_lib = cmakecache.chomp
            python_lib.slice!("PYTHON_LIBRARY:FILEPATH=")
            inreplace ["CMakeFiles/_fifechan.dir/link.txt", "CMakeFiles/_fife.dir/link.txt"], python_lib, "-Wl,-undefined,dynamic_lookup"
            break
          end
        end
      end
      system "make", "install"
    end
  end

  test do
    (testpath/"test.py").write <<~EOS
    #!/usr/bin/env python
    import os, sys, unittest

    def genpath(somepath):
        return os.path.sep.join(somepath.split('/'))

    _paths = ('engine/swigwrappers/python', 'engine/extensions')
    for p in _paths:
        if p not in sys.path:
            sys.path.append(os.path.sep.join(p.split('/')))

    from fife import fife
    from fife.extensions import fifelog

    def getEngine(minimized=False):
        e = fife.Engine()
        log = fifelog.LogManager(e, promptlog=False, filelog=True)
        log.setVisibleModules('all')
        s = e.getSettings()
        s.setDefaultFontPath('/Library/Fonts/Arial.ttf')
        s.setDefaultFontGlyphs(" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" +
                ".,!?-+/:();%`'*#=[]")
        if minimized:
            s.setScreenWidth(1)
            s.setScreenHeight(1)
        s.setDefaultFontSize(12)
        e.init()
        return e

    __all__ = []
    __all__.append('unittest')
    __all__.append('fife')
    __all__.append('fifelog')
    __all__.append('genpath')
    __all__.append('getEngine')
    EOS

    system "python", "test.py"
  end
end
