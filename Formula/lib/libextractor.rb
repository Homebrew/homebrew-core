class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftpmirror.gnu.org/gnu/libextractor/libextractor-1.19.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libextractor/libextractor-1.19.tar.gz"
  sha256 "2d5b33cbdb21c88ae9360994d4e216627413ee9cb11b31b033c2d0cf42ef2700"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "564174280de333db8510933759534e69021b82f17f1be0689b82e155451ed76c"
    sha256 arm64_sequoia: "8114de877b24ceec1b99fa25a63d88220595146c6f2782a407d1dc4252364938"
    sha256 arm64_sonoma:  "79bf379f9180159cde5736457d053ee98bd59ec48817e80e9846909cce44873e"
    sha256 sonoma:        "3f12e1073655ca34499d7f51bb0d24eab1de57b44aa32b05254494e48a35da98"
    sha256 arm64_linux:   "cdd86c28507ed9b56d66d5e31107822e2f94cf35cac0792c92d23712eb1da019"
    sha256 x86_64_linux:  "8648235d51ff13e908e9078653ebd7f5b8a0f325a629ac2653b8759a3083156c"
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "csound", because: "both install `extract` binaries"

  def install
    ENV.deparallelize

    # macOS defines ntohll as a macro, clashing with the local definition
    inreplace "src/plugins/qt_extractor.c",
              "static uint64_t\nntohll (uint64_t n)",
              "#undef ntohll\n\\0"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match "Keywords for file", shell_output("#{bin}/extract #{fixture}")
  end
end
