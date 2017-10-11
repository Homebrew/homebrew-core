class Ode < Formula
  desc "Library for simulating articulated rigid body dynamics"
  homepage "http://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.15.2.tar.gz"
  sha256 "2eaebb9f8b7642815e46227956ca223806f666acd11e31708bd030028cf72bac"
  head "https://bitbucket.org/odedevs/ode/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "d92f996fdad06e650f1f408e54ec531349be8899bbf42e2818718658069e9711" => :high_sierra
    sha256 "ade1ba4974e416c49ba02cc2b70520aabf4b79b2fa83e9cc560350e2d8268b68" => :sierra
    sha256 "eecd333626f8b081c9e245f46dcda62b8133ac1f99b63555771411d6f378fc85" => :el_capitan
    sha256 "2438a9e2e4484f85a94c7ac65759105ff4dec47128a5e48a37807e0d0ebc233c" => :yosemite
  end

  option "with-double-precision", "Compile ODE with double precision"
  option "with-shared", "Compile ODE with shared library support"
  option "with-libccd", "Enable all libccd colliders (except box-cylinder)"
  option "with-x11", "Build the drawstuff library and demos"

  deprecated_option "enable-double-precision" => "with-double-precision"
  deprecated_option "enable-shared" => "with-shared"
  deprecated_option "enable-libccd" => "with-libccd"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-double-precision" if build.with? "double-precision"
    args << "--enable-shared" if build.with? "shared"
    args << "--enable-libccd" if build.with? "libccd"
    args << "--with-demos" if build.with? "x11"

    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/ode", "-L#{lib}", "-lode", "-lc++", "-o", "test"
    system "./test"
  end
end
