class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.6.tar.gz"
  sha256 "cfb9cddb8377dc672b6793f942fd57ce99f3c248ab69ed55533de9e776fdc26d"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "2ef7ced25a969e67a7a127e067711be257571f0b2908bc2c5f654f97b5ee0614"
    sha256 arm64_monterey: "9d41b8342cf60993e2b154dde24efea951bd71a73ec76b3f248c1f16a6ac66f3"
    sha256 arm64_big_sur:  "e39f11dc215a1a0815a8b6e3ec2ba71afa2295539b9d35d04a930e578107768e"
    sha256 ventura:        "c54aad972da99df6e7f1fef9ac5665888457aff1f7b83e7fa1dd18d3e94a27b6"
    sha256 monterey:       "77631193b0c6e60e75648dc48dab6e56eaf673fbe7eb6cce91f3c0a6d987e7a6"
    sha256 big_sur:        "27b439115bd01cda515c09ab95ab9d5ae4a05f71b803bc55905d08d5ea28fb39"
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
