class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.5/dist/cubelib-4.5.tar.gz"
  sha256 "98f66837b4a834b1aacbcd4480a242d7a8c4a1b8dd44e02e836b8c7a4f0ffd98"

  bottle do
    sha256 "038e4978220fae83b1469f2a22f05c3fa01876c9dd6f9d3f7da13b6bc6335a87" => :catalina
    sha256 "ff5079cb8ddf09f12f73649cea99460b3fd112ba1dfc8791ed315d7b103031ba" => :mojave
    sha256 "8147b72304638d649a1416edca7616f68580af6c60a4b29e4ac2f8057ed258d5" => :high_sierra
  end

  def install
    ENV.deparallelize

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-nocross-compiler-suite=clang",
                          "CXXFLAGS=-stdlib=libc++",
                          "LDFLAGS=-stdlib=libc++",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    cp_r "#{share}/doc/cubelib/example/", testpath
    chdir "#{testpath}/example" do
      # build and run tests
      system "make", "-f", "Makefile.frontend", "all"
      system "make", "-f", "Makefile.frontend", "run"
    end
  end
end
