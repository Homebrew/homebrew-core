class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.4/dist/cubelib-4.4.4.tar.gz"
  sha256 "adb8216ee3b7701383884417374e7ff946edb30e56640307c65465187dca7512"

  bottle do
    sha256 "32d073bd808bd78c9fb4c679403bdd5045ca05798e620c52032e298a6eccf0f7" => :mojave
    sha256 "fba71475f80f96489fdc8d92785d9f64e3aebfead18c86380358a59bc66b8492" => :high_sierra
    sha256 "c64ad810675deb24b48111582b455df0d62738a267c991ca985bf139168f9313" => :sierra
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
