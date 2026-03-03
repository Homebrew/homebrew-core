class PdfZusammenfugen < Formula
  desc "Merge multiple PDF files into one from the command-line"
  homepage "https://pdfzus.de/"
  url "https://github.com/wsgtcyx/PDF-Zusammenfugen-cargo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e866659ec10df0e18f679906d6084a98b1420707f738a8933f14be69e839feaa"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pdf-zusammenfugen --help")
    output = shell_output("#{bin}/pdf-zusammenfugen -o out.pdf 2>&1", 2)
    assert_match "Bitte mindestens eine Eingabe-PDF", output
  end
end
