class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.5/dist/cubelib-4.5.tar.gz"
  sha256 "98f66837b4a834b1aacbcd4480a242d7a8c4a1b8dd44e02e836b8c7a4f0ffd98"

  bottle do
    sha256 "fd120eec0c9e3898317b924b1e0ab320afbc52730f2a97bc7d73e2164e7e9b87" => :catalina
    sha256 "32d073bd808bd78c9fb4c679403bdd5045ca05798e620c52032e298a6eccf0f7" => :mojave
    sha256 "fba71475f80f96489fdc8d92785d9f64e3aebfead18c86380358a59bc66b8492" => :high_sierra
    sha256 "c64ad810675deb24b48111582b455df0d62738a267c991ca985bf139168f9313" => :sierra
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
