class Libgr < Formula
  desc "GR framework: a graphics library for visualisation applications"
  homepage "https://gr-framework.org/"
  url "https://github.com/sciapp/gr/archive/v0.51.2.tar.gz"
  sha256 "e6a3d0ed911f6e59cc2293b5694ee18a0620849e666143870a9eda71c02bb833"
  license "MIT"

  bottle do
    sha256 "ac5472cbb7e312c22bc5048b472cd763c271866ad3e4c369bdb9b822e3b1dd92" => :catalina
    sha256 "941e72407cdbc7e193cfa6eaeb9bf6e0a497fed2b853df2d5537042776bba298" => :mojave
    sha256 "923de166a7fbf4bf8d15a85eac94f795cd6a5563c3a3d0acaf157823d65539f1" => :high_sierra
  end

  depends_on xcode: :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "libtiff"
  depends_on "qt"
  depends_on "zeromq"

  def install
    # TODO: Remove this when released archive includes
    # the fix of https://github.com/sciapp/gr/pull/101 .
    ENV.deparallelize
    system "make", "GRDIR=#{prefix}"
    system "make", "GRDIR=#{prefix}", "install"
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
