class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.2.tar.gz"
  sha256 "b26aebdcb015e2d89720ef48e0cb2e8a3ca77915f89d853893e7cc861f810f22"
  head "https://bitbucket.org/odedevs/ode.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "b033d3a8ddb92602728fbe921f5f421fed220c1d5293333d43801bf259a16cd5" => :catalina
    sha256 "0967cc5799fe66b3afff2c1fb9832e6d4ee7dde03f1388818de9d4b87581b4f8" => :mojave
    sha256 "7c794395db9cbb9d8d8c7a60d787c0747c527c4a177ef975e4bd6d4a8da1eb32" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libccd"

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-libccd",
                          "--enable-shared",
                          "--disable-static",
                          "--enable-double-precision"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/ode", "-L#{lib}", "-lode",
                   "-L#{Formula["libccd"].opt_lib}", "-lccd",
                   "-lc++", "-o", "test"
    system "./test"
  end
end
