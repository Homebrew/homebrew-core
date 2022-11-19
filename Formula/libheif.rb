class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.14.0/libheif-1.14.0.tar.gz"
  sha256 "9a2b969d827e162fa9eba582ebd0c9f6891f16e426ef608d089b1f24962295b5"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4f362e38b103cad94a9efa4262954f1eaf131d27aad0d2945b40140d3d707a24"
    sha256 cellar: :any,                 arm64_monterey: "961e0481b2ff19bc463963a9dd4e22dfcc9e896e84847b6e1e8164105c865b7c"
    sha256 cellar: :any,                 arm64_big_sur:  "42305ca6707b470406c80fcb42a90acb70be48e665469c67bc3b69b1c86cc816"
    sha256 cellar: :any,                 ventura:        "aa5bc96c47487d389139d68a7bc678e37cf1c29fab739091dcefa808630a2be8"
    sha256 cellar: :any,                 monterey:       "d52187177201c577e2a148c2f9d99f71dc42156a65ed553446cbe0a98975586b"
    sha256 cellar: :any,                 big_sur:        "a3ab4023b5ff07677f2d24c31dd16a9e0bc2285ed3e592b43a743d5c950dfa61"
    sha256 cellar: :any,                 catalina:       "b6a7ff7511e118258ff8a733c4322886db2ce8dde501fb7332d33af71b26f2c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1d44004038b86971f43edbd42ce6f6ed1daaf48ae64c1d1ad1eacbdc6406847"
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
