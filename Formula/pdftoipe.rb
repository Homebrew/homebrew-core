class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_monterey: "3b4d0ff51a0c2b8f85e7cf239979009bb8d3c510e9356edbe7304a830365945a"
    sha256 cellar: :any, arm64_big_sur:  "9176902206f020ed5d5a1ae986b5aa7e2cddfab1a8c8306841a66f0793e83baa"
    sha256 cellar: :any, monterey:       "7cff3a77dd401d8ca64b9300a59e0b354221a244105b4fe93525d8428f079445"
    sha256 cellar: :any, big_sur:        "c1f5b76d968cae9e1a3a0174acbdd3a3b39aab9493b4c6aa51854fe81cec121c"
    sha256 cellar: :any, catalina:       "476d3befcad88888c46b27ce26da98124f9e47af22adb6dedf4f7964b633d3b3"
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
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
