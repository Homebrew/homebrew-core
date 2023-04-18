class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "https://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha256 "80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6191ccb4d56cbb142a16bb7436f36dd0b5ccdcadf990b1004cdd49d285924004"
    sha256 cellar: :any,                 arm64_monterey: "06506916f644bbf3aa1138360c29f811a0bb0a5ab23cc2941a4e9a94c5c1f94a"
    sha256 cellar: :any,                 arm64_big_sur:  "c5716bd45fe8a883db5ca7b25d68dd7b31a04a5d9114aea8fbc1a2cd653d13c6"
    sha256 cellar: :any,                 ventura:        "384487c215497a3f18de1acd7982125783c80a67ab53e188bcef308d88ec3692"
    sha256 cellar: :any,                 monterey:       "0ee9976dd6fccec2cec2d9dd4fddf00a86400a9ad86eae581c7ce209bcb12a55"
    sha256 cellar: :any,                 big_sur:        "68517589d37a67656069fbb39cd57080f7887cd855a8533601dc09b77005e160"
    sha256 cellar: :any,                 catalina:       "459d6cd293c906cff22b981734661ab8d56c2269ab0c914ecd57e619f092a864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077ed4556feb380643d0aa9aab9bcbf1285f8b0c8f0702d422ab5c03c431668c"
  end

  deprecate! date: "2022-06-12", because: :unmaintained

  depends_on "jpeg-turbo"
  depends_on "libtiff"

  def install
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/jpegicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
