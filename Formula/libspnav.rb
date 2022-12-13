class Libspnav < Formula
  desc "Client library for connecting to 3Dconnexion's 3D input devices"
  homepage "https://spacenav.sourceforge.net/"
  url "https://github.com/FreeSpacenav/libspnav/releases/download/v1.1/libspnav-1.1.tar.gz"
  sha256 "04b297f68a10db4fa40edf68d7f823ba7b9d0442f2b665181889abe2cea42759"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "18dd7205e07c4380822fdf507f70aa5a460b942fb7aa2c6bdf064a0040426273"
    sha256 cellar: :any,                 arm64_monterey: "92c34da77f70181b7e459c709cd3b2dbca2d13d22891542b466b355e5fe52f5b"
    sha256 cellar: :any,                 arm64_big_sur:  "af3b951bb445de1a2eed22da15ececaaa94e02d810f796b602a6e2e36a16c997"
    sha256 cellar: :any,                 ventura:        "74b01153a841dfba2b57289432357977cac77d45c8e259aee15fa3b1a0324cd9"
    sha256 cellar: :any,                 monterey:       "526cd023fc31cb67690ca317f30054616e29699cea56443daeb8a77e89c8bd6d"
    sha256 cellar: :any,                 big_sur:        "6de5e4376307295e64248d5ede4a35ba9e7d90b513c758145a4b7aa4e71350e9"
    sha256 cellar: :any,                 catalina:       "84802266fecdc3162ffa9cef35b91df321ea50f65321440b9c3bef5befb8fdc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b381f749f71d3ca171b3e3b71482c53773d77b408bf7d698d3cb9629af04314b"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-x11
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spnav.h>

      int main() {
        bool connected = spnav_open() != -1;
        if (connected) spnav_close();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lspnav", "-lm", "-o", "test"
    system "./test"
  end
end
