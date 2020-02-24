class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.tar.gz"
  sha256 "4ba3b76f9c1314160de483b3db92b0569242a07452cbb25b368e75deb3cabf27"
  revision 1
  head "https://bitbucket.org/odedevs/ode/", :using => :hg

  bottle do
    cellar :any
    sha256 "794406d650c7ec28b44c593f68079eb4cdf21ccb7b86abec7060bb914b678dad" => :catalina
    sha256 "b4307a7a46c67cb8b4197dd196c11e497db5d4fc0603082ae19dc7120cd1b539" => :mojave
    sha256 "d03fd05d9762eaf7373c1502db1a21dc34028c880e713068ae0dc313de0a4b3e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libccd"

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", "--prefix=#{prefix}", "--enable-libccd", "--enable-shared", "--disable-static", "--enable-double-precision"
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
