class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 3

  bottle do
    cellar :any
    sha256 "f692c819249e96bbbe00ecb2240953a6b76f4b64d45532413711563e4b166d5a" => :big_sur
    sha256 "332ffd9755c4da9cef34de4b9a2913ecf5f1acf73a563d819348c126cbb2416f" => :catalina
    sha256 "cfac0579dc11896ce6164ed4872653810ee9221c6f03b99a06e4f754803bac96" => :mojave
    sha256 "580fda4da8f66cc7586ba9f8d1e8c12097f5a7dfd1fa7e38c56c14c54be214e7" => :high_sierra
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
