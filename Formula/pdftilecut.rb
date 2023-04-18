class Pdftilecut < Formula
  desc "Sub-divide a PDF page(s) into smaller pages so you can print them"
  homepage "https://github.com/oxplot/pdftilecut"
  url "https://github.com/oxplot/pdftilecut/archive/v0.6.tar.gz"
  sha256 "fd2383ee0d0acfa56cf6e80ac62881bd6dda4555adcd7f5a397339e7d3eca9ac"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d96b83fed8d3cacfbf13526f6be72a4b6ac8602dcfe73248b9e60cdfda3f9d45"
    sha256 cellar: :any,                 arm64_monterey: "d8c459893d9b12984b346151d7828373281c6d69d26e4a60408b0b74712b4df9"
    sha256 cellar: :any,                 arm64_big_sur:  "a0d25973d0b0900b2e6eba4e4044d8b737bcf7facb00d948ea6d0bc0b41d0da7"
    sha256 cellar: :any,                 ventura:        "369c7092b2e7592280e70b4d541dc0ff5de5eba9837d1f6972ca6eb2c089f5f3"
    sha256 cellar: :any,                 monterey:       "f3c41dc7753dabb9490068cab06ed59371ebf80a191bd6e653226febce0c8630"
    sha256 cellar: :any,                 big_sur:        "2bd8e248aab7550cbad72405e4ccc05b692fe8ccf99736076fd881212e315664"
    sha256 cellar: :any,                 catalina:       "23256aed8e1c3c2951ee5853b79e4c3d9eee84002680a6f7b24dc0c686fb0117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e750163fd2c39d4aac21c23952e8de9f28065d512d7da752690f96e9303de0f"
  end

  depends_on "go" => :build
  depends_on "jpeg-turbo"
  depends_on "qpdf"

  def install
    system "go", "build", *std_go_args
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system "#{bin}/pdftilecut", "-tile-size", "A6", "-in", testpdf, "-out", "split.pdf"
    assert_predicate testpath/"split.pdf", :exist?, "Failed to create split.pdf"
  end
end
