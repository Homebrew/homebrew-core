class Autotrace < Formula
  desc "Convert bitmap to vector graphics"
  homepage "https://autotrace.sourceforge.net/"
  url "https://github.com/autotrace/autotrace/archive/refs/tags/0.31.11.tar.gz"
  sha256 "da595b49d2419ef7f771533f46710c92a0267e380b8ff8a4ca8b9f2f41a76093"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/autotrace/autotrace.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "81a33f0be76186e8d6ed2c6533a0e502d9f9747ec69424958b7fed2c51349a09"
    sha256 cellar: :any, arm64_tahoe:       "70726ee0cc68faf87b08106363a0d89b7a82184916ba6806139f4d8fbbf86bf0"
    sha256 cellar: :any, arm64_sequoia:     "239cf73c61aa90bc71a7581d470aad88b5aead2c6e459217807b859af999af3e"
    sha256               arm64_linux:       "8a71cfd4c2cf335753439f535056b5e62dcb01a3905af6cab63b47ce66fbba75"
    sha256               x86_64_linux:      "b7d2b7ca67f69ce83f9b3c9cfb28644e1453d911d382c10b1110cbba53ebb69f"
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

  deny_network_access!

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
