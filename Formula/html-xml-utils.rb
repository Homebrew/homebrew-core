class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/html-xml-utils/html-xml-utils_7.0.orig.tar.gz"
  sha256 "e7d30de4fb4731f3ecd4622ac30db9fb82e1aa0ab190ae13e457360eea9460b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8367bc9df98ea4d766c07d003117a086e37a1f73eab4cc5b9d28704f2371b582" => :el_capitan
    sha256 "78dc134d1e22619091b8de99760a575c93f3bbfe1a243955c674072351297a11" => :yosemite
    sha256 "5a5de2f177a22f1d2272223f5b707a1ae6b2246cdc37094444a1bb996fe60728" => :mavericks
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    ENV.j1 # install is not thread-safe
    system "make", "install"
  end

  test do
    assert_equal "&#20320;&#22909;", pipe_output("#{bin}/xml2asc", "你好")
  end
end
