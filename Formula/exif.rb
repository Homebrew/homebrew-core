class Exif < Formula
  desc "Read, write, modify, and display EXIF data on the command-line"
  homepage "https://libexif.github.io/"
  url "https://github.com/libexif/exif/releases/download/exif-0_6_22-release/exif-0.6.22.tar.xz"
  sha256 "0fe268736e0ca0538d4af941022761a438854a64c8024a4175e57bf0418117b9"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "17692fb4a47365f4828c8dd22eb29e10f38fdb53e9eaeab0bb4bb06b86d9f8fd"
    sha256 cellar: :any,                 arm64_big_sur:  "6f8bd97c2b520c9ca089a39d2ae293f37e15a8049880c308a6413f295ef8b3fe"
    sha256 cellar: :any,                 monterey:       "e425f56e4fb8d296c47622010d341caf47e586e9ceeffd110d181598f80839df"
    sha256 cellar: :any,                 big_sur:        "9603f2b9c8b5efc9a83e2a9fb5b89fe2b4954567c39e814c2a8b81735c824063"
    sha256 cellar: :any,                 catalina:       "3d4f3d7c86e7c112f9164970cb5e283a96d82235c1633f15de6683b04ec7df87"
    sha256 cellar: :any,                 mojave:         "a600fdec30f561aaf97184c57ef77697cb617dd19795cb89201f9851646e9fad"
    sha256 cellar: :any,                 high_sierra:    "f8978e60a9eedc21fe0da30fa0a6bf900635635a5b1fa827473881b25c12d542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41aa53dd457e0318526a6ec043f18ff97a8a23a9009e0a556c271d0eae14d09"
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
