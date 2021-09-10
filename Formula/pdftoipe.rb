class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/v7.2.24.1.tar.gz"
  sha256 "561b18fc2a7ae45c37c5d0390443b37f4585549f09cd7765d856456be24e5dbc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8ed872e0ecd30981b531da0547e00c742c7876e4f78261fda53b72da6558e853"
    sha256 cellar: :any, big_sur:       "ccace122d290f8ba95e939985d11f058f5668514822f8eb2797c9a6e3c0217ee"
    sha256 cellar: :any, catalina:      "94de97b7700228f850bb9deb7a1daaee852df26e0e25665088385c0d751326cc"
    sha256 cellar: :any, mojave:        "8c5397f35ba0498e2086bb70c2a5c4aa21451519f1cd78a3ceb2459dd458e7d9"
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
