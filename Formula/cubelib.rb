class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.4/dist/cubelib-4.4.4.tar.gz"
  sha256 "adb8216ee3b7701383884417374e7ff946edb30e56640307c65465187dca7512"

  bottle do
    sha256 "130ce4f4c660f6f6fb56fcfe2908f76f0dd9de46687c358957b5892a524b9fdf" => :mojave
    sha256 "7f6bd7863a9d8b18ead409bfd6b32454c2dbec3dfec1cc9fd904b772a72d7ba8" => :high_sierra
    sha256 "584e847088b6183941ebbcdc7719e8f285879d1f3f76ebc9723a9a0e1b21a404" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-nocross-compiler-suite=clang",
                          "CXXFLAGS=-stdlib=libc++",
                          "LDFLAGS=-stdlib=libc++",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
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
