class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/v0.7.1.tar.gz"
  sha256 "b8cbd16f8dd5832ecfa9907d31411b35a7f12d81a5ec472a1555d00a8a205e0e"
  license "LGPL-2.0"

  bottle do
    cellar :any
    sha256 "4f19499edc025464f4ce74b0755ede3c404c41d131156aebd7d24ef3ca1fe64f" => :catalina
    sha256 "2852cb269611539d7d9fa227cca164318da3d1d3acec66b7a006ea958dc31d93" => :mojave
    sha256 "bef1ee9210f3591f0768817f4f748e49ea708742f56ce47e744bc4a1507f3f36" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "pango"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "--encoding=UTF-8", "-o", "paps.ps"
    assert_predicate testpath/"paps.ps", :exist?
    assert_match "%!PS-Adobe-3.0", (testpath/"paps.ps").read
  end
end
