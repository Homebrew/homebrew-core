class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.3.tar.gz"
  sha256 "a50c4d16dad660ad6792ef53bc77efa9d5729797623771a3fce52d8e23d3d08c"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4dd51b01bbec079bb106a4da0fac3881c6fa7b8013a44e4070dddc523c4fbe0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d05e54a669d9277dc02f0e32f62b5f429d62382c4896545e001c2c5f3a7cdb9"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d0bf8d477eb0b24fc8a0c39a4d6176983d2aa1ddb772e7d6c01f45d1b81b33"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6df6b38e77ddb76979b65bf3335e01a7cb6670d38de9acdec41c4d465f792d0"
    sha256 cellar: :any_skip_relocation, catalina:       "28ff1e5fe6d0a19c9e080acc813d49e5fa4bc074f0c009b89a9276a8de9c08d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a7e65aea3eb85a7c8c294ac6d06c87253292b13069a89b093670be1e48fce32"
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
