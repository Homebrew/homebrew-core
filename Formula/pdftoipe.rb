class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 5

  bottle do
    cellar :any
    rebuild 1
    sha256 "2e7dadf965cb9fdad3a3da5d543b49d84d36e8e3754bdaa758f80b741c0bb5d1" => :big_sur
    sha256 "86179f8c9ee6615a4be8cfac1d41f5b977043fb9b7947a9912ac1db054c633b9" => :arm64_big_sur
    sha256 "d6c1d9f995ccee31e08fde1a93aafbb625b15b4d7d0202f9182fba23dc50ac1d" => :catalina
    sha256 "d4ada38b8b4cdb67dd6749aab4d648914ab21bc40add8b36e28d4927d6bc9106" => :mojave
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
