class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.3.tar.gz"
  sha256 "4c959abb90535c61ce79c9583b0317dbada5babb46c17d77414c8bd9d42ad8b4"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "bde08d009bcd44c2fafd28eee52752aa567a1a4529f944ba5691521fcc982f02"
    sha256 arm64_ventura:  "0381bae60fff89d7dbacb577ddd99cdd1c1f64eaae839fba3862cb1b7970ffcb"
    sha256 arm64_monterey: "368aa98b6ffb21f9ea5386893b0d0a186dc2090d66033e55cf83771c402949ba"
    sha256 sonoma:         "fdb590a270aeae5da6d0844212727517e7a57d2bfe52e46579e6d335315698e5"
    sha256 ventura:        "74c6d40952d9c3fa66dd73b45e9a83b82a492cb9b4464ff9989dcaddd034fb9b"
    sha256 monterey:       "f5016d856e756e811214943983d0fd750291bf033c6918d77d16a1f5435a3a14"
    sha256 x86_64_linux:   "bf776be92abb265a7a7c013c22861e70f1ff35c4de79e800b85d2874fac521af"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "ffmpeg@6"
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
