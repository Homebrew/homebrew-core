class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.20.1.tar.gz"
  sha256 "233f5629986ade3d70de6dd1af85d578d6aa0f92f9bcd1ecd4e8e5a94b508376"
  license "GPL-2.0-or-later"
  revision 10

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4f92fbb31e4351fd4f18de880b11a4f211d9129608e1d69a998065ae6f7c2cf0"
    sha256 cellar: :any, big_sur:       "e16cd0ace3188156bd07f56073d1670407178662ad6554cdb7c62697807de0d5"
    sha256 cellar: :any, catalina:      "abc528000696cc93745b45345ad85fb752914a50e85686b9340ad23497a767e1"
    sha256 cellar: :any, mojave:        "1e5b6d720afc7a4f0cf8eb66b5637d5a9d85bb3512da7449d06cac3aa43a2c70"
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
