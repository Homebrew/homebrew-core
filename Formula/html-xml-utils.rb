class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.4.tar.gz"
  sha256 "2541c3e1f22f0bb2e66e846f8e4fd3afb95b80ce71d37853fb962ba7a1caef12"

  bottle do
    cellar :any_skip_relocation
    sha256 "80fbef5853a14f820be9936de99456001aabe014e30dc50ee6f7e42b9c514bda" => :high_sierra
    sha256 "8a167685dbaf9e08d6e40c300326914403f8a72d76eef71c37819923c27a2c74" => :sierra
    sha256 "a7559f75d244d994bd2934422e8309b5dc4c28bf5282207b88e80ebeece8428b" => :el_capitan
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
