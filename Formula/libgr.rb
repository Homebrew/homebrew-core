class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.71.3.tar.gz"
  sha256 "b9bf0bdeb8ce896d7cc01e79468fefdadecc09cab94183920783921fcad65eda"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "80f58ae673cc7ce41d5655073169199b6acd3388fc4e76a1ab60c643ae2e2289"
    sha256 arm64_monterey: "266617ae0625f6f26314cb70980397d9a700008ba773e46cd7ad41c36c3abc0f"
    sha256 arm64_big_sur:  "630fd5703a264d99856e99869e9a02d5fcd8a928aaf380b7b6d7c3ee28bc29d3"
    sha256 ventura:        "35f8c323c8724692ec113de5f55cbb96f9c6e53b4ea57dad3e38098e1d44b759"
    sha256 monterey:       "1381056732de8fca1e899f745c59309d7ae06a6c3e4d753d96a06dceebb346e4"
    sha256 big_sur:        "fda0c517bccf000b07c0a1878338755d0f9a017ad1ee1b30855b4d6aae27fc09"
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
