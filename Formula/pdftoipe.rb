class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 11

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d578ed23ceac30c4d9092769f566723018ddd5facfe0a2cc713e0bc4faaabc18"
    sha256 cellar: :any, big_sur:       "57ec6b5b7c1dfafe7e278b0f1539d0486efe9a679fa0557e483beadba852bae3"
    sha256 cellar: :any, catalina:      "a3533c326f8b1fddbd61c6b3c167d1cf0c0690d230f50fbe99b852b5f87c544c"
    sha256 cellar: :any, mojave:        "f02a6fa619fde074fdb7088dec0d82d7800de5b0ae6fbcfd7326fbfeff3ec124"
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
