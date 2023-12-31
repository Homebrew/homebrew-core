class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "258e946fe87acb0d59124e8adabf934f109165eb4b866978cda3a72a6dcb57b0"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "067be481037e0ce7f52b139969cdcf65ec26feae339d30da01bf7ca492259e9b"
    sha256 arm64_ventura:  "2fd8a06631fb0db9785c9dfbce0a3895f320dc74cda54586229ba2a12432d238"
    sha256 arm64_monterey: "0f4dfa0757ccc95a0f104da1b26cb8853e6346e0c8fa86e6808233f08e87eeff"
    sha256 sonoma:         "14b28e64eabe73df4b47a89c17124b2db1786f40882435a1dcc3f3755ee3496e"
    sha256 ventura:        "01f6c240302c343d47515e8ed67d8e687ea07f1f5cb157bf3ae1852ec8590a97"
    sha256 monterey:       "246181e95aa0ef3842319e199a3b28ee3dd5674502071c6e133e4ff21bb4a097"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <gr.h>

      int main(void) {
          gr_opengks();
          gr_openws(1, "test.png", 140);
          gr_activatews(1);
          double x[] = {0, 0.2, 0.4, 0.6, 0.8, 1.0};
          double y[] = {0.3, 0.5, 0.4, 0.2, 0.6, 0.7};
          gr_polyline(6, x, y);
          gr_axes(gr_tick(0, 1), gr_tick(0, 1), 0, 0, 1, 1, -0.01);
          gr_updatews();
          gr_emergencyclosegks();
          return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lGR"
    system "./test"

    assert_predicate testpath/"test.png", :exist?
  end
end
