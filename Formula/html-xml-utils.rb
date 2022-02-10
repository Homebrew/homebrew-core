class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.2.tar.gz"
  sha256 "00db3cc6877c885bfcd4009933ce7d427d472156f2502a27ca16bcaf01faae64"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e561c8418a190e9f0077b272772ac10d5989e6f8c9347bfd89a67bdf0f0b15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2e8b48180f2522ba7ad4ab2f2ce902b9128effefc3af13553c60f033ed56583"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7263df94ebb71949f8333cc4c00e86403f1a56272c50c321e9e54ea7e02a9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "088d099b3a98f165598ca6e25994be506ad6c977eb55914dfb9632870f3486ab"
    sha256 cellar: :any_skip_relocation, catalina:       "4aa66ce8cb77c75ce4e204721994f8717c8572d3d74c14ae2952d4a67b1e02dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05e5f5d2d80aa8dbb6d51db3fe6a3814528a9483902436082acf09cbd84179fe"
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
