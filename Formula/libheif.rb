class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.10.0/libheif-1.10.0.tar.gz"
  sha256 "ad5af1276f341277dc537b0d19a4193e0833c247b2aacb936e0c5494141533ae"
  license "LGPL-3.0-only"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ad14eb7498f8e3ce88eab7080d5bab96a76625146f08f93d2c415a9c4a457300" => :big_sur
    sha256 "668a7d16b976d5083224495433d20258b9b74dac82ea18ff3c01b95e9274290a" => :arm64_big_sur
    sha256 "977d0b6b904a292dad214bfbd3e44d9f1bd5ea5b308f69d96153208333a037f1" => :catalina
    sha256 "8e0cd658a818526c599bec0d22cd52ab854f49a46912729a0792c92fe86d45c9" => :mojave
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
