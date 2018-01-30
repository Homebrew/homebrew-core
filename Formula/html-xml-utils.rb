class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.5.tar.gz"
  sha256 "16412bf5cb87a23a7484849931724df40ad86331edd57de68c842dc292c27531"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed260f2672ab4836e648328a17a9474e65bfd36f40c72bddbe0c0b139a863da1" => :high_sierra
    sha256 "a29711836fd51afdc5358ed8989841222d63c217f48225f711484a89138cbcd0" => :sierra
    sha256 "c92c51c63af6f05cb945792634eb14ec26cbff8c162bd9a70a0f1b8c69c7eecf" => :el_capitan
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
