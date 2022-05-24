class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/v0.7.1.tar.gz"
  sha256 "b8cbd16f8dd5832ecfa9907d31411b35a7f12d81a5ec472a1555d00a8a205e0e"
  license "LGPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "64750f6318462484efbf5d4656bf75896fae72f2abf0636182e27ad9ba77915c"
    sha256 cellar: :any,                 arm64_big_sur:  "f8ab36ee220f8e2bfd5fb7db1c16812241ec8212cfc3ecd7c070517ac0a104b0"
    sha256 cellar: :any,                 monterey:       "c1b2eb436a7cc57282726120aa8f5a03f1b76c70af74760ede5525be695db75b"
    sha256 cellar: :any,                 big_sur:        "1ceacf866bec6fbe8329ef4cac025f5ccb1bccda7616ffebd0fdd24fcc33e13c"
    sha256 cellar: :any,                 catalina:       "4f19499edc025464f4ce74b0755ede3c404c41d131156aebd7d24ef3ca1fe64f"
    sha256 cellar: :any,                 mojave:         "2852cb269611539d7d9fa227cca164318da3d1d3acec66b7a006ea958dc31d93"
    sha256 cellar: :any,                 high_sierra:    "bef1ee9210f3591f0768817f4f748e49ea708742f56ce47e744bc4a1507f3f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee348bc7685c17d5453ca8f661b98020849d5c0265ec30cba5ab8321a6333bd3"
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

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

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
