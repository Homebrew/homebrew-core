class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/refs/tags/v0.73.5.tar.gz"
  sha256 "834f5c0185cdd9750c4a9e4b1c2c1c3cf63f8b49ba62165a3de2dcbf1d072b9e"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "3459ea88b3a236639f4c861d13b19ead51d90e3c9e7bd059c5ba6fe2a7601ea7"
    sha256 arm64_ventura:  "c07c0df4e1e2e644f686a6f8856bd7ef38bbfe390749aa959c54c9f40af00a59"
    sha256 arm64_monterey: "cda5d679f287b8a9810ed83e93ff03dbc90ef31abee75ca78524dc02aa4ea65c"
    sha256 sonoma:         "617d35a75d17d503b0ff9f29b886f45ccb6f3616f750e1caff238ca8d26fb313"
    sha256 ventura:        "090e668393c2e0353c3b899d27045b8793419ed3fe9d5b324790ea429d2b54ad"
    sha256 monterey:       "d95a4b9be0d1f4881aff17d02d94471ae18fb7f9e1844b45cc94f07759d71074"
    sha256 x86_64_linux:   "51311a2442498277eb55c74ec5781a25fcca0eaef93e5f6ba2a7cc71a50ee144"
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
