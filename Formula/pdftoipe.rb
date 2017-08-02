class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.7.tar.gz"
  sha256 "889cb31bd8769ba111f541ba795cf53fad474aeeafbc87b7cd37c8a24b2dc6f6"
  revision 2

  bottle do
    cellar :any
    sha256 "85aa695a9ba5499638715218e01599e9539aeb0c8e3103b76973a0f45cebec91" => :sierra
    sha256 "06b8471437a8ddec7b006fd6dc195ed999520d4e757ed2491416fff82a7fc42d" => :el_capitan
    sha256 "c607733278c26ff6df7054af9c10a8ca6430494acf932a359bcd1ab9c98f982a" => :yosemite
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
    assert_match "Homebrew test.</text>", File.read("test.ipe")
  end
end
