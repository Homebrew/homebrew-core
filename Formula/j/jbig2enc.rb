class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/refs/tags/0.31.tar.gz"
  sha256 "35c255e44a9b1c4cbe27d2c84594a43d6666645156a2d186ba60f8832566141d"
  license "Apache-2.0"
  head "https://github.com/agl/jbig2enc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f891a70f1ee77aae491741f33f4718498ef2859ff6e54f99addf231c20b7995"
    sha256 cellar: :any,                 arm64_sequoia: "07646fddb19b2d6d979d71c8ba3aba6fa6ac20807c94310103cfd9fdc36ad53c"
    sha256 cellar: :any,                 arm64_sonoma:  "81e82a6e5d88e69072db240ded35bc888c415c9568415f896725ae0d6527cebb"
    sha256 cellar: :any,                 sonoma:        "4ce999d38b53b62920792c1e7eddecd7595c904b015a067bfda16f8059fd9958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c15b19e0b6ce06f494d892d14bcebfe91219eaf92374964f818c374ccf1e8fca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33324d8a8e539387b1313dbf974f202b2ebc890ee61b796fb03f73ccfda05464"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "leptonica"

  on_macos do
    depends_on "giflib"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "webp"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/jbig2 -s -S -p -v -O out.png #{test_fixtures("test.jpg")} 2>&1")
    assert_match "no graphics found in input image", output
    assert_path_exists testpath/"out.png"
  end
end
