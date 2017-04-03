class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftpmirror.gnu.org/gzip/gzip-1.8.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gzip/gzip-1.8.tar.gz"
  sha256 "1ff7aedb3d66a0d73f442f6261e4b3860df6fd6c94025c2cb31a202c9c60fe0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f83c850ee014942640b63359e13e3e9da4d2db1d2728c54bd847078ba7817777" => :el_capitan
    sha256 "79c5b405d59ef30ada49058299483d8d5d83bfcb2d4d42f61cd89f805b1f4f2a" => :yosemite
    sha256 "55e0259951ced98bca53980b203b1bf63ae776720a85e4030484795367d3971d" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/gzip", "foo"
    system "#{bin}/gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
