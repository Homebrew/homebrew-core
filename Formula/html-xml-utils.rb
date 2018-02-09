class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.6.tar.gz"
  sha256 "75f810ec1aee60c62b9f25a79f048fc510b63797c271349030deaf8480be2751"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e0e4c223e8ac0e205be284a0ab4e5f07c473c5b1c9815bf44883de7b3b28a69" => :high_sierra
    sha256 "95290a4929db2b46d65834bb98177ca08f5f8a915d71c7b6014d6b9ae08d05d4" => :sierra
    sha256 "85b73c2f7b2f981ec398889144f9874088020887a710ef8428af1fa473e13c22" => :el_capitan
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
