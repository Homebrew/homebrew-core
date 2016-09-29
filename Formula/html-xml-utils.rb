class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.0.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/h/html-xml-utils/html-xml-utils_7.0.orig.tar.gz"
  sha256 "e7d30de4fb4731f3ecd4622ac30db9fb82e1aa0ab190ae13e457360eea9460b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc697acb107e868b85de256a8676ae5ce04881cb6064961f73359210157c8e9f" => :sierra
    sha256 "f4fcf1eee59d579dd13abe97c77a04775b63d4d027d34343ba38d49c18edb1a4" => :el_capitan
    sha256 "1b314be3c1fb27d27d68005e612e6b73b97997c487b4f69e39580e3ec3875d83" => :yosemite
    sha256 "bba2efae933879389e92302fbf9989b501c351f6e2353d08b381e950eeb6435f" => :mavericks
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
