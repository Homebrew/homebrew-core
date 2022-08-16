class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.66.2.tar.gz"
  sha256 "caafaeb9ca79f52f6137653bf344ac1357789da9218a235177ad7aa1de2759d7"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "24bb91259dc37c3d780aa7645cf07a5ae7b8486345b233d2226c3534984fe8fe"
    sha256 arm64_big_sur:  "ce3d6bf3b6ecb6464fffa39b675df82d8b338fc0a5e771abedd47cbd16437ff3"
    sha256 monterey:       "7a0fdddc25671d61dbd4674cdbd6c216973fe11f8416a3754aad33b838401066"
    sha256 big_sur:        "bcaa202793088d1481d53585a06963ee8872fd9942cb46133d45ef39a9e0288e"
    sha256 catalina:       "0952284a45f50f9cd7454911c6227fa1b64be84000a0b33cacf195334b01ba4f"
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
