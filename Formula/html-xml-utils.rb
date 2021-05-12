class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.0.tar.gz"
  sha256 "749059906c331c2c7fbaceee02466245a237b91bd408dff8f396d0734a060ae2"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f1ced37ea6d241aadbad55e5119bedc0f7cbaf6ea3d11b9ee98f6f7bb9a4f3d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "df00f5b0bb8b3abe68d158e4995507e7e5beb4d4a3cae89d55c5739c81b7bf62"
    sha256 cellar: :any_skip_relocation, catalina:      "ef675b85f70efc449e2f64e28dae04434ea984214a1c3c4e92d78c8d21975878"
    sha256 cellar: :any_skip_relocation, mojave:        "b35399870d1a81ee93bfa03fcf191148ddd8775280b038ee3c0fc55b71a9fcb4"
    sha256 cellar: :any_skip_relocation, high_sierra:   "4ec7374987c3ab57fdc4b33596e934e62b37c437c6114b190fdf026029f6329c"
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
