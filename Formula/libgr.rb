class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.66.0.tar.gz"
  sha256 "b29e101b0c916720c5ae8215bec74fc313e86310ff0474067a2ddf113fbbe2c7"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "6060f8e912c89023e62d853280c4bf16a7f52f8f9e4c4a19656450a5662575a7"
    sha256 arm64_big_sur:  "4c8465f176d7ad78cb1e6f36b7ed548bfea5935457e75c56f8034b9e50b6e3fe"
    sha256 monterey:       "1977b5db56f8ac79e974666b0d4e3ab75a96697e398160cae04421be4d05fa97"
    sha256 big_sur:        "700491245e4ef1c6e98fef62e65f3423a5e1ab74937c3cb04426a6fdd39344d8"
    sha256 catalina:       "54ee17612f31172a5d4c40eee7bdfb8c235946f21d2f7490765de9d83bfcdaf4"
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
