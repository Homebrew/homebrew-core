class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.3.tar.gz"
  sha256 "4c959abb90535c61ce79c9583b0317dbada5babb46c17d77414c8bd9d42ad8b4"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "0167b73e5be6a02604869e66677c3b1a9e5856e8025f406e2848cfe1d057e6f8"
    sha256 arm64_ventura:  "bc5163474748b43d66c460bcf8062b70432c54f9d627b57e24b63c2400f9320a"
    sha256 arm64_monterey: "8bb45a480fd1557ee7fb1a04fa2751ffa3277bd755dfb60f66db956a6d578656"
    sha256 sonoma:         "f0bdcca6e7cd3377da7d9d7484dafc25d8e7e48a2cc5f5dc34eb97d15e7e8164"
    sha256 ventura:        "0f0af7a63154956e9f6026164123a0e127d3edee350436cce1353c5de041aeed"
    sha256 monterey:       "d3817d2929acd3c35b1e2db0e8764ff587705d17dd3f51bcbff07d340dfdeef6"
    sha256 x86_64_linux:   "9fb9f79a8391585f3e3559faf1bf445318eb7f6139d263eaaa8809a5b0859750"
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
