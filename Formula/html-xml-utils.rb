class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.6.tar.gz"
  sha256 "75f810ec1aee60c62b9f25a79f048fc510b63797c271349030deaf8480be2751"

  bottle do
    cellar :any_skip_relocation
    sha256 "64176b3356d26c3467dfb182a28d4724fee74181191e8e719c93f705cc6a1329" => :high_sierra
    sha256 "043e115bd9135d1d0ebe9cbceae1c2c8b826abea8b845d99b91fa8252622ab5e" => :sierra
    sha256 "7ad2d1091290328f64ac652e8180d89646b7479dcbad4c37b38846442ca1682c" => :el_capitan
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
