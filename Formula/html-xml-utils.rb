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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c16a3cfc6c495dc7dcfd4c91d783468ab0b2d06080a50ff9d2ee22a005a549af"
    sha256 cellar: :any_skip_relocation, big_sur:       "d091c52a06b99739740d1d3c293bb76cf648a892f973b51d05dbba8224981637"
    sha256 cellar: :any_skip_relocation, catalina:      "8963544c153ee5d40ea25a7f28ecee4f6fcf7e631e7ea294b5b92c551e0848da"
    sha256 cellar: :any_skip_relocation, mojave:        "528fa00404d4a9b5b14afa4df46ea6ae9bd74b984a6f21b747bcbfb4b3773360"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38dd92ab8c435790ffbd448a74a89562050fbcfa0f2af0dad4cf1aa34ca7a541"
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
