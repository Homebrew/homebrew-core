class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.18.3.tar.xz"
  sha256 "fb995ef21dce6c73dd0dd454ba3e0f7fac08e053ea16060a2e5ce69a3746ee27"
  license "LGPL-3.0-or-later"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6aeb3a346d23942bfc95e7842083383922329bcb4e278b8e0a72c584e3c6b5e7"
    sha256 cellar: :any, arm64_tahoe:       "ed19e393a53d7ec520b2069025f0aa81c96748406bcec2459b84692fc246bdf6"
    sha256 cellar: :any, arm64_sequoia:     "10f0a5ecd32eeda9d686c8e95e8d7879e310ff82b49ebd8bfa0c599f90551d15"
    sha256 cellar: :any, arm64_linux:       "c12794fcb731df0de6b65fe1e8d1bce817b35d91b28c640e4245583e4958fd08"
    sha256 cellar: :any, x86_64_linux:      "8b3f78baca160275b6b154b185c9714a9cb14d6d4c5340e43967b93876f6a849"
  end

  head do
    url "https://github.com/hpjansson/chafa.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "libavif"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  deny_network_access!

  def install
    with_env(NOCONFIGURE: "1") { system "./autogen.sh" } if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    man1.install "docs/chafa.1" if build.stable?
  end

  test do
    output = shell_output("#{bin}/chafa #{test_fixtures("test.png")}")
    assert_equal 3, output.lines.count
    output = shell_output("#{bin}/chafa --version")
    assert_match(/Loaders:.* AVIF.* JPEG.* JXL.* SVG.* TIFF.* WebP/, output)
  end
end
