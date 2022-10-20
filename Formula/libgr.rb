class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.69.1.tar.gz"
  sha256 "e7b685d74ec08061876f2bc122365684ef727f1f1a0004262ee8d1e856ae0315"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "51ce7ce8f112f6cbdee1267695c38d6c518dc74ddadd7d40e5239e447408ec0e"
    sha256 arm64_big_sur:  "e31091558f988df65405449d7ed3b169172b6cf0a469e51a0ad771cd982c8db1"
    sha256 monterey:       "c48922468de343494988b4ee50284bcedd5d2eda47298688465370cb1a71c79a"
    sha256 big_sur:        "a88589ba514f1556cdc80e31104cb6976d9f2a8ce91e79c3329c689c2c5f645d"
    sha256 catalina:       "b9d61289b6cb5bf4a598f354d9facc27fbece5b41eb8fed0bf201699fc4be8a9"
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
