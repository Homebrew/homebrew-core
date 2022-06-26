class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.4.tar.gz"
  sha256 "41bb9b14e1f4cd6102e3f8dfb79e7146a24c09693869873165c421769a57d137"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66e08eeaa55322e3e088c454ca5dfa536dfb006af028431f49dde19603de08c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "266bde745a50183463b375f937ee0b6352f25d49c8d0fea63984939fcbc340ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d57473f0754a2f146c74c87774c1aaefaac8e82b168f31208e1fd92db461a721"
    sha256 cellar: :any_skip_relocation, big_sur:        "94028fe5988b7d67104d8bac2b751b2b96fc07710ff045cff56365c8677e96f6"
    sha256 cellar: :any_skip_relocation, catalina:       "8aa10fdafb70c37a904da4dd86b9498d6cfdf9b11e00db7f6eeb27140cac27d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcedcb2a41de4451a870f08cc23b38f45e209d849a00c9664b6b67053d920be0"
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
