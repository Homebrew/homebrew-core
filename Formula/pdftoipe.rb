class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any, arm64_big_sur: "43b0ee0611b0edb25891da16d05b72c527b97a74f27639bfad4d17ef3256ca1f"
    sha256 cellar: :any, big_sur:       "a9229ec69c846d47beab278fda331680910cabee55d9faaae1c3cb410987083a"
    sha256 cellar: :any, catalina:      "7cb8aff11c8626ce8b1de9f9292dc6c34fdc270dab3b4ceac5df9a2454acfce4"
    sha256 cellar: :any, mojave:        "86c1b8f8e9878d4f8ba421c5ace5d78d541c68dc79fde6115e4855de2adb0a63"
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
