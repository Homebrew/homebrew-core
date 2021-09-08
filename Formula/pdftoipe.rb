class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f58bcb87bb561efab6c057ef6d7621540a0973f9391e6bc6efdff7901013c8bb"
    sha256 cellar: :any, big_sur:       "f1ed5121b666a15d3538d4760deb9d433c3bf98e71f92f43c61af57c8b6ff505"
    sha256 cellar: :any, catalina:      "bee0f7584d1fe032ec72c07cdf204c9cafc9a00faf4291f6bcc556fd806881c0"
    sha256 cellar: :any, mojave:        "34fa2d743d807b71afd2a38df51c2b1de9bb0a61b696fe8a395993500ebcaf27"
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
