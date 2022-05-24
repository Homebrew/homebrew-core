class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.12.0/libheif-1.12.0.tar.gz"
  sha256 "e1ac2abb354fdc8ccdca71363ebad7503ad731c84022cf460837f0839e171718"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6285488bd07d49e996a1be0dfe7296051ade71cc2078ecbaa2243afd05afe560"
    sha256 cellar: :any,                 arm64_big_sur:  "ccf8a9fecc4629a5ae7b7cdb2db8e86c74cf70ab345f960d513e45b57f646174"
    sha256 cellar: :any,                 monterey:       "b2cadb8ecf0985f007340e54853ffa685f57fd4dba8cae4bae37499119a9fe04"
    sha256 cellar: :any,                 big_sur:        "6a82cb078278ee9e6240b6c738308974ca3a4ef545c30016f8395967bb6f4959"
    sha256 cellar: :any,                 catalina:       "9ed1d527c347fa67d346d5d638b1760177693819d167c7dc549ebabcaabc428c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6382a34a85ddc5cb1a8359de883c18867340294b2f662e84650b287f04324484"
  end

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples/example.heic"
    pkgshare.install "examples/example.avif"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"exampleheic.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleheic-1.jpg", :exist?
    assert_predicate testpath/"exampleheic-2.jpg", :exist?

    output = "File contains 1 images"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end
