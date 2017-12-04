class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 8

  bottle do
    cellar :any
    sha256 "80b72e7954e151e38abd0d5ccd12480f737f4aae5c8a6395208345ecae3332c6" => :high_sierra
    sha256 "dbec98a8d704c2e4cd4fc33b12deb21dfcd617032e5c5ffe294f0ab02ab36621" => :sierra
    sha256 "3219cb4ba1bd914f62278a2a610c78dbfb40cc377fec0e84501507ce343e9616" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  needs :cxx11

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
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end
