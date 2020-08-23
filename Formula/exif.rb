class Exif < Formula
  desc "Read, write, modify, and display EXIF data on the command-line"
  homepage "https://libexif.sourceforge.io/"
  url "https://github.com/libexif/exif/releases/download/exif-0_6_22-release/exif-0.6.22.tar.xz"
  sha256 "0fe268736e0ca0538d4af941022761a438854a64c8024a4175e57bf0418117b9"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "3d4f3d7c86e7c112f9164970cb5e283a96d82235c1633f15de6683b04ec7df87" => :catalina
    sha256 "a600fdec30f561aaf97184c57ef77697cb617dd19795cb89201f9851646e9fad" => :mojave
    sha256 "f8978e60a9eedc21fe0da30fa0a6bf900635635a5b1fa827473881b25c12d542" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libexif"
  depends_on "popt"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-nls
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "The data supplied does not seem to contain EXIF data.",
                 shell_output("#{bin}/exif #{test_image} 2>&1", 1)
  end
end
