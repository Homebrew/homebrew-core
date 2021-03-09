class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bccabc517bbc2c3a48108fdcb944aa0de84a19d8fb39acb2fe7cd8e36521fa1e"
    sha256 cellar: :any, big_sur:       "e2e2cacca9f434cdcf2914f2145de772fc132d42243681d6f7e8ce1739610e09"
    sha256 cellar: :any, catalina:      "506ca131e673cbbed3564f3c40bf1dd9c9dda1f542d5c9dc93e6243fff88d4cd"
    sha256 cellar: :any, mojave:        "5751badc621bd2d3a8263cad30c8f6c14b67fa27847f50647a68efbb9fced148"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    ENV.cxx11

    cd "pdftoipe" do
      system "make"
      bin.install "pdftoipe"
      man1.install "pdftoipe.1"
    end
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    system bin/"pdftoipe", "test.pdf"
    assert_match "<ipestyle>", File.read("test.ipe")
  end
end
