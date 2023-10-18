class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.1/imlib2-1.12.1.tar.gz"
  sha256 "d35d746b245e64cd024833414eef148a8625f1bed720193cd5c2c33730188425"
  license "Imlib2"

  bottle do
    sha256 arm64_sonoma:   "340686a62cc73b407b8865ff898036958d36ae3cd44748a79ce04ed3c255d51c"
    sha256 arm64_ventura:  "24a12ac9285633fe1a0f844331d19abcde5dd99520edbe0432ea687cd64f1f25"
    sha256 arm64_monterey: "72815d83d4ff40106b987e870ebbcaaad10786abc8a581747e9339dcb6a67af4"
    sha256 arm64_big_sur:  "5c0a0f84abf3ff248989ad1d38f7c2cb41988ac3063d0e034fc3f64303adfc3f"
    sha256 sonoma:         "34f0974010b985d40c0636a1587c8f81b2614b4b364541216e473d154550be3a"
    sha256 ventura:        "0d99ef3348e92763a8e2adfea2857cc8d3145e7cbefbc6a8209445096d6e58d1"
    sha256 monterey:       "844f5e867091e1ddaee95f600cedfad67b9397748f5d53ccebba7e4b8c1bf8be"
    sha256 big_sur:        "1b4b17a721c859d2a1ef2cbff577794aa713ee1c1a63b13d0765696146b30f4d"
    sha256 x86_64_linux:   "abdad19e9b3ce85b4793639b24044bb88850021efd826074eef6ef213a6f3e71"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-amd64=no",
                          "--without-heif",
                          "--without-id3",
                          "--without-j2k",
                          "--without-jxl",
                          "--without-ps",
                          "--without-svg",
                          "--without-webp"
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
