class Chafa < Formula
  desc "Versatile and fast Unicode/ASCII/ANSI graphics renderer"
  homepage "https://hpjansson.org/chafa/"
  url "https://hpjansson.org/chafa/releases/chafa-1.18.3.tar.xz"
  sha256 "fb995ef21dce6c73dd0dd454ba3e0f7fac08e053ea16060a2e5ce69a3746ee27"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://hpjansson.org/chafa/releases/?C=M&O=D"
    regex(/href=.*?chafa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "03f87f827bbd5ee2bcf7dad29443629fbd98bdd2d8b5d6434c597ccac08514aa"
    sha256 cellar: :any, arm64_tahoe:       "993191e48f92a6583f02438b5aa34315f927700a333e1c92be3e70d947c76e62"
    sha256 cellar: :any, arm64_sequoia:     "0e1847feab9deb2ffb78703d877d9602d8b8f2745c9061e354d5a92e8d476412"
    sha256 cellar: :any, arm64_linux:       "4e3d9342907b11258c07465bbf91e57e098628a300bf62149fd005ea865908eb"
    sha256 cellar: :any, x86_64_linux:      "4a6278c0108bb2df7d65f5d2afed3e8d943043da1aae7950cac098dd484409aa"
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
