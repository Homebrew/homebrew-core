class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.72.9.tar.gz"
  sha256 "0b8b86302be706bef5e04223f5bf52c1bbd6299339b6615276676e84405a6311"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "079944b07c50d7b3f53ec93b057d3a1f743b95ec1eb20da8eb955ea06a5d4af2"
    sha256 arm64_monterey: "6d0188cf27c1b419ce2f2bab9249847b2fe810d8bc355aaf6b48f06ac1dc5003"
    sha256 arm64_big_sur:  "09ee9877276d9c9214a4240f041ee84faafcba542180201e308b6a684641396c"
    sha256 ventura:        "d6ba79f3eae86f745d8ef1698bd1488966a4079e82b3a491cad98a6b3ac7c0b9"
    sha256 monterey:       "b4a57685de4a8fca8e01b579411807fe84f1e8daad1aa4a0d7f0c98eadcee4ab"
    sha256 big_sur:        "308dcf6126b0e8ea2d1784c17c4dc8473fb13d2483636b42e536a76e8e449a37"
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
