class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.72.2.tar.gz"
  sha256 "03cc08779e1b06a885c9b6fa45954ec50e3b45dd94067c46a462bf66138eb566"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "c66b7b597a7e0747fe593a85db1ada9cd17e5914bc141d051d4a1651a66977fe"
    sha256 arm64_monterey: "5de8f137d8bd4b5d7834af26b679bd210f20260d4aaf102338f78790043132d6"
    sha256 arm64_big_sur:  "f442a5eff3c538c478dc11551cbb863cba07272700ca159e64bc19b46df82420"
    sha256 ventura:        "26be90067e8c1045b938d30bc50dd6eeaf873f31e8e29b5a66da9d50f5d7e323"
    sha256 monterey:       "0c866ed18ef8c0afecab9b721ebed87d5605d37a66b8733d82d7823e5c41b8df"
    sha256 big_sur:        "f619d4fb3721a0ec6d58f192613ab51d209760d3019a4e6f1cd18ddc99531c31"
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
