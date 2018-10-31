class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.15.2.tar.gz"
  sha256 "2eaebb9f8b7642815e46227956ca223806f666acd11e31708bd030028cf72bac"
  revision 1
  head "https://bitbucket.org/odedevs/ode/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "dc84a857363f79acf047a85ce46a3e371a478d92adbd84407bc30ca0e7658ef5" => :mojave
    sha256 "d00577ab819d9e29a3c4712aa6a5bb19ebba8db82e534552d33b3d102c9cdebb" => :high_sierra
    sha256 "2a01fcc4ae6ff0e197dfb66a15fe068873297c8063f5552bb80d0c10fe5383bf" => :sierra
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
