class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.14.2/libheif-1.14.2.tar.gz"
  sha256 "d016905e247d6952cd7ee4f9b90957350b6a6caa466bc76fdfe6eb302b6d088c"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d29c850d7b82f0a983c12c0d6c7fef074112bd1314faad3f6cdfd724599a798"
    sha256 cellar: :any,                 arm64_monterey: "72e03dc47c1610fd9cb5efad52bab6e14bef95801b9f2730e362faa137defa5b"
    sha256 cellar: :any,                 arm64_big_sur:  "ea9692d6f45ea703c36c197d1fae996e59434138f44cf0b0aef6a3e3c000fa1c"
    sha256 cellar: :any,                 ventura:        "27f2646f9f32331fffa2b85785a69772136d46b6d2e960cef1cc36b3280a998b"
    sha256 cellar: :any,                 monterey:       "af29a0c1c1773a7c5a3933c98bb1da669c4de25513e4e9149a7547ee87b27160"
    sha256 cellar: :any,                 big_sur:        "4ce7b5d8d5d7798898b5c3971deb2e1c9b10c973f1e43bac947a9b1a536af047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56459426ca044e911104995106decb4bb8c674dee83c7ca47c972b08d5d5d1c5"
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
