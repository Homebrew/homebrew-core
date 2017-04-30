class Flif < Formula
  desc "Free Loseless Image Format"
  homepage "http://flif.info/"
  # When updating, please check if FLIF switched to CMake yet
  url "https://github.com/FLIF-hub/FLIF/archive/v0.3.tar.gz"
  sha256 "aa02a62974d78f8109cff21ecb6d805f1d23b05b2db7189cfdf1f0d97ff89498"
  head "https://github.com/FLIF-hub/FLIF.git"

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "sdl2"

  resource "test_c" do
    url "https://raw.githubusercontent.com/FLIF-hub/FLIF/dcc2011/tools/test.c"
    sha256 "a20b625ba0efdb09ad21a8c1c9844f686f636656f0e9bd6c24ad441375223afe"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install", "install-dev"
    doc.install "doc/flif.pdf"
  end

  test do
    testpath.install resource("test_c")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lflif", "-o", "test"
    system "./test", "dummy.flif"
    system bin/"flif", "-i", "dummy.flif"
    system bin/"flif", "-I", test_fixtures("test.png"), "test.flif"
    system bin/"flif", "-d", "test.flif", "test.png"
    assert_predicate testpath/"test.png", :exist?, "Failed to decode test.flif"
  end
end
