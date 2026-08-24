class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/refs/tags/0.32.tar.gz"
  sha256 "5b3b1c48617e5b1608f916a78038ea867a2c9eb20c2ff34a78a48a243f655c2a"
  license "Apache-2.0"
  head "https://github.com/agl/jbig2enc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9fd3c0c264b30f2a02ab8b89ac8e684ab515cd44e88cb14f679c99d25c092354"
    sha256 cellar: :any, arm64_sequoia: "2c317add0084e4ea90899553bd9fd59ae0fed098471da10fc94c8b01bae45973"
    sha256 cellar: :any, arm64_sonoma:  "961556bab15d1a444bcafbd269ec257cbce72a7af3895e3fd42f728ef8b4d8d3"
    sha256 cellar: :any, sonoma:        "b6a585484142a139e3f4098e73b93b3f47582906ee13e1c14c1c36fb86ec3d52"
    sha256 cellar: :any, arm64_linux:   "b9a2c69947b0a64fe0345887b7a1f0cc28839cb3b2eb20dd3b8936e444a8b748"
    sha256 cellar: :any, x86_64_linux:  "a8268db37b8aa99d56d32848d58420d851728275a699b0ef7520035c79d45f8b"
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
