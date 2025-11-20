class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/refs/tags/0.30.tar.gz"
  sha256 "4468442f666edc2cc4d38b11cde2123071a94edc3b403ebe60eb20ea3b2cc67b"
  license "Apache-2.0"
  head "https://github.com/agl/jbig2enc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4cac7beea1281386d93c5a6a086df2f628165c1b61829c2c1607715ae5e892a"
    sha256 cellar: :any,                 arm64_sequoia: "c3277ead02053270075af72039bcd3f2e2d712fddda586284f9b5b00a6ea672f"
    sha256 cellar: :any,                 arm64_sonoma:  "bde53a1f5b1257541002a926ab14fcfefe91b3408df67eb9dbc2e27584d6b596"
    sha256 cellar: :any,                 arm64_ventura: "3e12cce5a16f9427104fa24c1b8665d8d0cc58b22b77d2d1b7d74ef4dbba5d46"
    sha256 cellar: :any,                 sonoma:        "73b88ab1c2f8c17beda9109e62935813bce19ce84970b935ef810715c48d21f6"
    sha256 cellar: :any,                 ventura:       "988b1d72ea105c139b59ba60e4cd00beac878f647f1594d2657340878acb135b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f1cda60e433c0a9e450ebac66c1cd12646f57a5fe691969870a45f96c21352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11281bffe9b33acf9e62c446ae9af7332b4154a87d9d58f3ba15b9d550198d93"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
