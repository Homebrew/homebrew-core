class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "https://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.16.2.tar.gz"
  sha256 "b26aebdcb015e2d89720ef48e0cb2e8a3ca77915f89d853893e7cc861f810f22"
  head "https://bitbucket.org/odedevs/ode.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3b69d29b04c4c733c4689be24f1ab4b49f646485650a6a55c10f2721de44e53b"
    sha256 cellar: :any,                 big_sur:       "333320201f493ecb42eb9754a8c73d8490aa8d0155129865384fe2faf2706482"
    sha256 cellar: :any,                 catalina:      "b033d3a8ddb92602728fbe921f5f421fed220c1d5293333d43801bf259a16cd5"
    sha256 cellar: :any,                 mojave:        "0967cc5799fe66b3afff2c1fb9832e6d4ee7dde03f1388818de9d4b87581b4f8"
    sha256 cellar: :any,                 high_sierra:   "7c794395db9cbb9d8d8c7a60d787c0747c527c4a177ef975e4bd6d4a8da1eb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c87822ff6ef6053ad8ff8b6e2c6a5ba7e4383addba94d898a88f513fca3522fe"
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
                   "-L#{Formula["libccd"].opt_lib}", "-lccd", "-lm", "-lpthread",
                   "-o", "test"
    system "./test"
  end
end
