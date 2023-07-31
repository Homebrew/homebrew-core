class LiveChart < Formula
  desc "Real-time charting library for Vala and GTK3 based on Cairo"
  homepage "https://github.com/lcallarec/live-chart"
  url "https://github.com/lcallarec/live-chart/archive/refs/tags/1.9.1.tar.gz"
  sha256 "860d57bd633bd1c8c6d387190d8d5ace39fe4a8abb26c0a40bb0c8d263c7a3c0"
  license "MIT"

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk+3"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.vala").write <<~EOS
      int main (string[] args) {
        Gtk.init();

        var chart = new LiveChart.Chart();
        chart.refresh_every(-1);

        return 0;
      }
    EOS

    system "vala", "test.vala", "--pkg gee-0.8", "--pkg gtk+-3.0", "--pkg livechart", "-o", "test"
    system "./test"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/livechart.pc").read
  end
end
