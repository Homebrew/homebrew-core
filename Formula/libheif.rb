class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.13.0/libheif-1.13.0.tar.gz"
  sha256 "c20ae01bace39e89298f6352f1ff4a54b415b33b9743902da798e8a1e51d7ca1"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e6b5488552092caa2741a3c18b443895eb418928f45acbe78ad443fa430cc353"
    sha256 cellar: :any,                 arm64_big_sur:  "9d1cbc5abeafe2dd4c28c8509f70402c9ebbe2e6988b9542430b7b439214e449"
    sha256 cellar: :any,                 monterey:       "5560c274fcd7bd4e378f9b05cbe359ad350b9e7cb8dc4aef80568621781eac50"
    sha256 cellar: :any,                 big_sur:        "1d1010a85df362aa99790b11411f937e78765a38c72eb18c0f1b6cdabda4aaf6"
    sha256 cellar: :any,                 catalina:       "3cb661d104c3c9ca427072ffaf46672216b570c4d48d55a248749345969126f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "911716d44b3a2f160ef24ff965cc5b0ff29a084a098be261982e40e60d97c04b"
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
