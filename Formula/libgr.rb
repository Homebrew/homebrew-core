class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.64.4.tar.gz"
  sha256 "b9866f1c9496817023c0d7f23d92bf7c5bdcbe669a1e744a7e839b5f34baf501"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "288ed3006520942e964fa8cf9b5f2ffe3b4524016d0ddc257138acacb1a8dbc1"
    sha256 arm64_big_sur:  "bec4daa0463755a98fd820eb9c0bcde3a67f78353e0e9ceb16d4e1b81977d687"
    sha256 monterey:       "18ea54c4500635ff1a0cfe1c4a61b93f5c5dd245f30ecb5de5a4d7679ab2fc6a"
    sha256 big_sur:        "79b5ca609c897623d6248379f1c1ad6a681b98e77afde0113729993a70a202c5"
    sha256 catalina:       "69fa14ef8d35fef54d9416e68fccc51d389f8ba8d21849528192a417816629be"
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
