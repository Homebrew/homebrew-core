class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "https://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"
  license "LGPL-2.1-only"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4b835b95d956e232aaaeab9a3602fb3d0c34c1eba0a86051f3b33d09466f185e"
    sha256 cellar: :any,                 arm64_monterey: "1af4fb9e89cbb182c0b5e000afdbc2f2554f0021f39577137fc63d95128ba5e2"
    sha256 cellar: :any,                 arm64_big_sur:  "4f64b4f61ae37827b11b457f83ee4bc5d9a0fc97be6bbb48abd065b95cb90caf"
    sha256 cellar: :any,                 ventura:        "cf544a62e926e1a1db81937e6a29ca993c5f453ec7cb9923d31d71beb033d111"
    sha256 cellar: :any,                 monterey:       "78e02a8c690a050325e431d228f160fc9a1f811e7053aa8a0dfa914393ecbe6c"
    sha256 cellar: :any,                 big_sur:        "da721497db16566e8d473c538b229124a44410e2a6f2ca9844a818d12bf40832"
    sha256 cellar: :any,                 catalina:       "79b0955210000433597e1687e0658d3dc11905a2a1b0d87a70b3d843d7d534e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa324892691800b8a6a35e4e657631b728af9c2f5a63a6fed167e7f796ea0068"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "openjpeg"

  uses_from_macos "sqlite"

  resource "svs" do
    url "https://openslide.cs.cmu.edu/download/openslide-testdata/Aperio/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource("svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end
