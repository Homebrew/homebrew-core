class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "http://www.libheif.org"
  url "https://github.com/strukturag/libheif/releases/download/v1.3.0/libheif-1.3.0.tar.gz"
  sha256 "f37a1c3ac505fefabcc1a0f639823c91359e1418f1c8861db630692f1d381526"

  bottle do
    cellar :any
    sha256 "d93963bed0c1d05eaba7e839b8fa1e9924f31b9f665089c6e8fb8471cd0e35f5" => :high_sierra
    sha256 "5f7e645a68923af5336aa24a5ccc675d203723816e63f4760018db60d5dc6880" => :sierra
    sha256 "7d7caae49f70d6c16ee6ba257289ba5dfbba3435818d16334f0987d2a3edfe6b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "x265"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples/example.heic"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"example.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"example-1.jpg", :exist?
    assert_predicate testpath/"example-2.jpg", :exist?
  end
end
