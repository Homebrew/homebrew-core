class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.15.2.tar.gz"
  sha256 "2eaebb9f8b7642815e46227956ca223806f666acd11e31708bd030028cf72bac"
  revision 1
  head "https://bitbucket.org/odedevs/ode/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "db6d5149c20d30e8ce3492ea197f27c2d0506b8c290576ffb08b82e8b64839ce" => :mojave
    sha256 "d392aba8c14119ee6072c2677835e928d9a9cca95d4b3c0ef0b82aedf1bc0147" => :high_sierra
    sha256 "34670979e3b841475cbbef0038203bae036baa753a6c03af179a0aff7b27d168" => :sierra
    sha256 "4f2986f5867bd16da6836dc9a580f1ca2a01f4d7177fd3308b4fcea41443ac7e" => :el_capitan
  end

  option "with-double-precision", "Compile ODE with double precision"

  deprecated_option "enable-double-precision" => "with-double-precision"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libccd"

  def install
    args = ["--prefix=#{prefix}", "--enable-libccd"]
    args << "--enable-double-precision" if build.with? "double-precision"

    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", *args
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
