class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-7.9.tar.gz"
  sha256 "d86ac96ea660316bef814c17b2a96d54cdf91c69e59614459865c2bfdaee433f"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "df00f5b0bb8b3abe68d158e4995507e7e5beb4d4a3cae89d55c5739c81b7bf62" => :big_sur
    sha256 "f1ced37ea6d241aadbad55e5119bedc0f7cbaf6ea3d11b9ee98f6f7bb9a4f3d1" => :arm64_big_sur
    sha256 "ef675b85f70efc449e2f64e28dae04434ea984214a1c3c4e92d78c8d21975878" => :catalina
    sha256 "b35399870d1a81ee93bfa03fcf191148ddd8775280b038ee3c0fc55b71a9fcb4" => :mojave
    sha256 "4ec7374987c3ab57fdc4b33596e934e62b37c437c6114b190fdf026029f6329c" => :high_sierra
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
