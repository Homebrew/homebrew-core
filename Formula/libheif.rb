class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.15.2/libheif-1.15.2.tar.gz"
  sha256 "7a4c6077f45180926583e2087571371bdd9cb21b6e6fada85a6fbd544f26a0e2"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "820ec916a81cf91d385596cb2297d892d576e9791adb689f79d2d6e6642b79e8"
    sha256 cellar: :any,                 arm64_monterey: "7b59662e0359fced6a059a03aa923c2f497d3d1d926775bc6405ab479cf6b447"
    sha256 cellar: :any,                 arm64_big_sur:  "4ad052a3cb99944e8d1deba4ed1646f445cb614400a86dc2a806a616b84d46b5"
    sha256 cellar: :any,                 ventura:        "eec3c8c7ac9c1ec1a7a1a14b7257cb3c98da9d09900914f5d65a92a07290ae5d"
    sha256 cellar: :any,                 monterey:       "05f4a370d81bf44021672c0e7a9eeaa68e9683ad8dc0dfaf1bb4b2c3c935b427"
    sha256 cellar: :any,                 big_sur:        "b8cbb5c9724515ec8a4c1adab9e322cbdf08845d2671eb41f08c41dd35f0bdb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d4e7ec91a69c67812ce959e25871af7412966f82e15cbcb9a873cce3389df1c"
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
