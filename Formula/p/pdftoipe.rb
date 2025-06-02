class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.2.29.1.tar.gz"
  sha256 "604ef6e83ad8648fa09c41a788549db28193bb3638033d69cac2b0b3f33bd69b"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e93f97375ae15498043bc1cfe9733bd2939f2a000817f4c497a055407e13349"
    sha256 cellar: :any,                 arm64_sonoma:  "dcd657a43dbc49efb2f2de2bf4a78c6ed1e93576365e97947e2f78e006851e0c"
    sha256 cellar: :any,                 arm64_ventura: "ce7e36a7df776d6955d39cae2ac448785c1f0e791a623448bc6b4e3faf6198d0"
    sha256 cellar: :any,                 sonoma:        "7668361aa148108d8d71cee8242525543fdd6228a3ea4bb94e3d216a84f919ff"
    sha256 cellar: :any,                 ventura:       "a1d8e7abc1851aff252b5ee0925843a8cd3f32587730a5da3145d970c1905bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d9edff97cc36b7050ed98a75baeba2184f941710ca7257b10d7cad82b48fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13364e0ade978267567a9687c4a783c7761b6cb9b8bab6f2c77b147d91414711"
  end

  depends_on "pkgconf" => :build
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
