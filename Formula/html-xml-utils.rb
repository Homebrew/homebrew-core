class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.8.tar.gz"
  sha256 "9ab41c9277efc699603d062c10740c6e528fdb9ac35014db4e07f16ad8700d5d"

  bottle do
    cellar :any_skip_relocation
    sha256 "28e913a33a61be2662a9aeedb18afd3e61f7ff31f533221e2382fc16845984a2" => :catalina
    sha256 "8e290495b957bc609598e4a2e6fb26512011e0c433a5058d807d86e406a406ab" => :mojave
    sha256 "2aa00ada9b366c012d149ff28c99d0054a7b166d2088700482e6118e16580358" => :high_sierra
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # install is not thread-safe
    system "make", "install"
  end

  test do
    assert_equal "&#20320;&#22909;", pipe_output("#{bin}/xml2asc", "你好")
  end
end
