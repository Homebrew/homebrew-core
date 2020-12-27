class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.53.0.tar.gz"
  sha256 "a348602c3e2d928b5c293a19ed91e126bf56e23720d4f0e12aa92767da767276"
  license "MIT"
  revision 3

  bottle do
    sha256 "1ae1c4c80659db2c9505449acc52f0f6328054caa287af5bcc9e755771d8c382" => :big_sur
    sha256 "add1a726255e0f7e2ab1346c26349f846a617717df799e3dcb1c3f67f9e5128f" => :arm64_big_sur
    sha256 "504017bdc9b08bfc637c26f2c4f9ad6a2a6f02c96ecb00f76768e9a039ddb77b" => :catalina
    sha256 "1ba1b40c849d496da5d24d924a9211a25bacd7a4cd5eafb0e9a2be970a694686" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qhull"
  depends_on "qt"
  depends_on "zeromq"

  # Use .dylib extension on macOS
  # https://github.com/sciapp/gr/pull/128
  patch do
    url "https://github.com/sciapp/gr/commit/81f6f66b9766eb876e64dff43a6b1a802536ccac.patch?full_index=1"
    sha256 "15dd98e65172a7354dc27d4858c6e06ccafa040d451171bf5e770596668478d4"
  end

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
