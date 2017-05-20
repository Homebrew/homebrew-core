class Ode < Formula
  desc "Library for simulating articulated rigid body dynamics"
  homepage "http://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.15.2.tar.gz"
  sha256 "bc481ae33f8e139b7beebb18bcb43df5c0251ff9518d82794b393ba1407bae96"
  head "https://bitbucket.org/odedevs/ode/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "ade1ba4974e416c49ba02cc2b70520aabf4b79b2fa83e9cc560350e2d8268b68" => :sierra
    sha256 "eecd333626f8b081c9e245f46dcda62b8133ac1f99b63555771411d6f378fc85" => :el_capitan
    sha256 "2438a9e2e4484f85a94c7ac65759105ff4dec47128a5e48a37807e0d0ebc233c" => :yosemite
  end

  option "with-double-precision", "Compile ODE with double precision"
  option "with-shared", "Compile ODE with shared library support"
  option "with-x11", "Build the drawstuff library and demos"

  deprecated_option "enable-double-precision" => "with-double-precision"
  deprecated_option "enable-shared" => "with-shared"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 => :optional

  def install
    args = ["--prefix=#{prefix}", "--enable-ou", "--enable-libccd"]
    args << "--enable-double-precision" if build.with? "double-precision"
    args << "--enable-shared" if build.with? "shared"
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
