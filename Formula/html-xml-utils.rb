class HtmlXmlUtils < Formula
  desc "Tools for manipulating HTML and XML files"
  homepage "https://www.w3.org/Tools/HTML-XML-utils/"
  url "https://www.w3.org/Tools/HTML-XML-utils/html-xml-utils-8.5.tar.gz"
  sha256 "f20a46ac4ed30d028cd78476e5f20f5e2917a95cb7bce7df7f17d8fb3e4f79e7"
  license "W3C"

  livecheck do
    url :homepage
    regex(/href=.*?html-xml-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9da23d056da555fbf6306037ce4469b1c2e65390c8ca5f01bff0da44ebe31cde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d4975799b15c7ea41ccfdd3d41362ae9a28456f013f44a32c0ac5539d49c6aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7e79fe524c0876f73ec73b51db43965941c3a4d902071bab0a3084bdd88f84c"
    sha256 cellar: :any_skip_relocation, ventura:        "52130fde2b7dcd1c01153665df9b35c53841e424c1b92c481298cc971c829373"
    sha256 cellar: :any_skip_relocation, monterey:       "8fdab1c6c0a1143e276a47cf25af5acdf5a4648ae97432c94feebb4756e8632c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2a33cf64b5ad4f023f55005b206d43b3a2c035de031a2566ce7738b06f81cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf02ccbd70a98f31080c719ac354b16857b5a15baaa417da2869be0d23e0638"
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
