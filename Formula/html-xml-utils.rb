class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.3.tar.gz"
  sha256 "945db646dd4d0b31c4b3f70638f4b8203a03b381ee0adda4a89171b219b5b969"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb03ea1bb3658075026732e8bcdaa1cb620f3720bbca9efa36ea9dca221d6b18" => :high_sierra
    sha256 "df82c4fbbac299f07207b286680c03a734283a1c5b7dad95ce32af2dc062419f" => :sierra
    sha256 "b45407684af8cc1756bafc6a5b18d816b061bd0900517d45fc13648bd597743c" => :el_capitan
    sha256 "80243f59807c769f5695322dc6a04aa1cae19818c7994068c8c5c029b60fb410" => :yosemite
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
