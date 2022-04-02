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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc4a5306db037a3dd8f808b00e3c254ff0784dc2c592c73e7b3c086f8ebf9000"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d53dc65d8418c37f057a326c7d18d256ac008996f1d497fb5b4810f63ff24d8"
    sha256 cellar: :any_skip_relocation, monterey:       "d0b8f48ef3abd66ba812f29ef6e95ea2debf3e2e2e954e07f01b89343abc8f3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc8533ee17932face08e77e99f96778caaad3e83d7883d7b4056d372b92bc582"
    sha256 cellar: :any_skip_relocation, catalina:       "1cc7d7092a7ed4fa8c5967632c38cedf5555f73a7972d43a5185b506283319d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e17a30dec5413978d0fe1d6fdae36da0b7eb781daee3e3ade08f628b5c74076d"
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
