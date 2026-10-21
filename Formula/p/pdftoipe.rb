class Pdftoipe < Formula
  desc "Reads arbitrary PDF files and generates an XML file readable by Ipe"
  homepage "https://github.com/otfried/ipe-tools"
  url "https://github.com/otfried/ipe-tools/archive/refs/tags/v7.3.1.2.tar.gz"
  sha256 "edb8f098c32f0ae626ac20ebdd0f2114fc1d1cc4d730a7abb648cfe9c131e40d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9d0f60bcaefa22fa0d3b7ea75457e767d5232ae5f8b58cddd848bcdb241fde69"
    sha256 cellar: :any, arm64_tahoe:       "e35dcb1395e75b638212d36be26cb747197de46f39c66c251d52fb4aa71b6cb1"
    sha256 cellar: :any, arm64_sequoia:     "7de44d51f6057f20717726fd8d4c7364ba53af1bf405a7dc68ef24d7c9105534"
    sha256 cellar: :any, arm64_linux:       "9192e9a2551397c3b333541a65a4d76844d6a28685d69c3cf9bd2fd4e9c1dbb6"
    sha256 cellar: :any, x86_64_linux:      "ab5fd4cd156359e431bf77d1e504b4ac957239ea628c7de789294899b0d33834"
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
