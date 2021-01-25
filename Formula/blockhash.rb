class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.1.tar.gz"
  sha256 "56e8d2fecf2c7658c9f8b32bfb2d29fdd0d0535ddb3082e44b45a5da705aca86"
  license "MIT"
  revision 2
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "18aff0ad3432de881f61cf760c2582d04edcd464815c0295fb16ce1b3d33e25d" => :big_sur
    sha256 "cff3b941522479a8ba44c7cb75f972308ee5f8575189e20304d6b249a6d01465" => :arm64_big_sur
    sha256 "fccd88402eef1d464bc0acced536611fb01370b401eea3c81646ea76f6c71ebc" => :catalina
    sha256 "80fbbe34b7fdba30703797df3ca288cba9471586ddb1ef024d11ea8f03d913db" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "imagemagick"

  resource "testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  # Add python3 support
  #
  # This patch mimics changes from https://github.com/commonsmachinery/blockhash/commit/07268aeaeef880e0749bd22331ee424ddbc156e0
  # but can't be applied as a formula patch since it contains GIT binary patch
  #
  # See https://github.com/commonsmachinery/blockhash/issues/28#issuecomment-417726356
  #
  # Remove this in next release
  resource "waf-2.0.10" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/07268aeaeef880e0749bd22331ee424ddbc156e0/waf"
    sha256 "0a855861c793f9b7e46b0077b791e13515e00742e1493e1818f9b369133b83d7"
  end

  def install
    resource("waf-2.0.10").stage buildpath
    chmod 0755, "waf"

    ENV.prepend_path "PATH", Formula["python@3.9"].opt_bin

    system "./waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "build/c4che/_cache.py", "-fopenmp", ""
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
