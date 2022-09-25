class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.13.0/libheif-1.13.0.tar.gz"
  sha256 "c20ae01bace39e89298f6352f1ff4a54b415b33b9743902da798e8a1e51d7ca1"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56393746a6a2b778fea34efd0f54bb021cbbd3037e5331e7bd43692c7197afc0"
    sha256 cellar: :any,                 arm64_big_sur:  "90e4cd50afc636c2c5a4c65ef24e69dd8b4e8882972835f674827974bf31829b"
    sha256 cellar: :any,                 monterey:       "c430a3ac250cac7589d3d5a1b49e646bddc8ad612a9539967e407448209c38c0"
    sha256 cellar: :any,                 big_sur:        "645812fa238861a35d8969c8a024b21cec7d196c243215dc851915602d840ceb"
    sha256 cellar: :any,                 catalina:       "903dd8b70663ea86f9be75da09b3fe721d484a2075ed4dd9cabd539c736ea772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8430376a3c220ee03cae6abfd71fca61fd47d581bb2bea011d02c29f28fafbc"
  end

  depends_on "pkg-config" => :build
  depends_on "aom"
  depends_on "jpeg-turbo"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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

    output = "File contains 1 image"
    example = pkgshare/"example.avif"
    exout = testpath/"exampleavif.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"exampleavif.jpg", :exist?
  end
end
