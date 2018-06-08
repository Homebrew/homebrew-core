class Inkscape < Formula
  desc "Professional vector graphics editor"
  homepage "https://inkscape.org/"
  url "https://inkscape.org/en/gallery/item/12187/inkscape-0.92.3.tar.bz2"
  sha256 "063296c05a65d7a92a0f627485b66221487acfc64a24f712eb5237c4bd7816b2"

  depends_on "boost-build" => :build
  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "boost"
  depends_on "cairomm"
  depends_on "gettext"
  depends_on "glibmm"
  depends_on "gsl"
  depends_on "gtkmm"
  depends_on "hicolor-icon-theme"
  depends_on "libsoup"
  depends_on "little-cms"
  depends_on "pango"
  depends_on "poppler"
  depends_on "popt"
  depends_on "potrace"

  needs :cxx11

  # Fix for poppler 0.65, remove in next version
  # https://gitlab.com/inkscape/inkscape/commit/fa1c469a
  patch do
    url "https://gitlab.com/inkscape/inkscape/commit/fa1c469aa8c005e07bb8676d72af9f7c16fae3e0.diff"
    sha256 "c53ebb25f6e1e4153c837c7e2ce8ce270256c9c121cd96fe1add922f5df66992"
  end

  # Fix for poppler 0.64, remove in next version
  # https://gitlab.com/inkscape/inkscape/commit/a600c643
  patch do
    url "https://gitlab.com/inkscape/inkscape/commit/a600c6438fef2f4c06f9a4a7d933d99fb054a973.diff"
    sha256 "510861d5a242c2456e8bfd6d0eb666b5a192c02bb435f9beeee114af77a9aaa5"
  end

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/inkscape", "-z", "-f", test_fixtures("test.svg"),
                              "--export-eps=test.eps"
    assert_predicate testpath/"test.eps", :exist?
  end
end
