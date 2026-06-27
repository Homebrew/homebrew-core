class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.net/"
  url "https://github.com/autotrace/autotrace/archive/refs/tags/0.31.10.tar.gz"
  sha256 "14627f93bb02fe14eeda0163434a7cb9b1f316c0f1727f0bdf6323a831ffe80d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/autotrace/autotrace.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "45e3c79261a2d2396b54c3b190c32125c89e3d9959111dd35d89cf1a44c504cb"
    sha256 arm64_sequoia: "6213320bb304ff6333289b861b9f52a5268911df82335066bdddabf5992c290a"
    sha256 arm64_sonoma:  "ee95b6e4026bce275bad5e9fa04838c8c572e12f57c02aafc0773783c89b15ee"
    sha256 sonoma:        "1abd8cfd21e0fc4709b0360d742caf8497aabf57d1386e10dece107a33389810"
    sha256 arm64_linux:   "0768105a4d211cd8ca546f8f78e64c5e77375d4fa5da1f3d54736f4feadfef14"
    sha256 x86_64_linux:  "1128ec1cefbf6143258dcf9ed0b6ef805d1bc92e0bc5cc88ecdc9774199a5860"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pstoedit"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./autogen.sh"
    system "./configure", "--enable-magick-readers",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system "convert", "-size", "1x1", "canvas:black", "test.png"
    system "convert", "test.png", "test.bmp"
    output = shell_output("#{bin}/autotrace -output-format svg test.bmp")
    assert_match "<svg", output
  end
end
