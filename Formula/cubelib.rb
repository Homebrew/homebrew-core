class Cubelib < Formula
  desc "Cube, is a performance report explorer for Scalasca and Score-P"
  homepage "https://scalasca.org/software/cube-4.x/download.html"
  url "https://apps.fz-juelich.de/scalasca/releases/cube/4.6/dist/cubelib-4.6.tar.gz"
  sha256 "36eaffa7688db8b9304c9e48ca5dc4edc2cb66538aaf48657b9b5ccd7979385b"

  livecheck do
    url :homepage
    regex(/href=.*?cubelib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "6b647d7c7673d0b4b95c7240dc477ee13e0fdd5c9f8952bd9b8d80b0f3f55d4d"
    sha256 big_sur:       "2680056fa693e78f9f89fcaa55b67888c4aa2d947cc4a2c9d2167e3380782517"
    sha256 catalina:      "5b03ba168b4d88c74b68409a9d7fc5b6aca796a78b7e55d29a1cba2d29e1595a"
    sha256 mojave:        "5eca16fc5e707d28e6595f070a49516d65a46aa495b95ab78616777027e36114"
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
