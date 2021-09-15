class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.12.0/libheif-1.12.0.tar.gz"
  sha256 "e1ac2abb354fdc8ccdca71363ebad7503ad731c84022cf460837f0839e171718"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3963465a6971ee520138cd03749c8117f5c804e2631c326d765ee49f7a044517"
    sha256 cellar: :any,                 big_sur:       "446b22420364f8914e39777b3c99a7a94035287e0d881e4ca3b0682093f6f2fe"
    sha256 cellar: :any,                 catalina:      "3e852c84854a7beb0dc3e4ece0c5b161e35271c0eb68c1a1f86f2a3f019c2aa7"
    sha256 cellar: :any,                 mojave:        "a03dba57d45f433a2ab7ae145641aea1ef7b1838aeb49c60847be2e529513079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0b0d1ac463d83ebd3614d0cd6215e2460efe562caf1cfeb634e2eff9454807"
  end

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

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
