class Pdfc < Formula
  desc "PDF Compressor in C with Ghostscript"
  homepage "https://github.com/Huaqo/pdfc"
  url "https://github.com/Huaqo/pdfc/releases/download/v1.0.0/pdfc"
  sha256 "49d59d93180d0a8268b0057c62c4c7653382400167cd0a2f8e2da65c05c89ffd"
  license "MIT"

  depends_on "ghostscript"

  def install
    bin.install "pdfc"
  end

  test do
    (testpath/"test.pdf").write <<~EOS
      %PDF-1.4
      %âãÏÓ
      1 0 obj
      << /Type /Catalog >>
      endobj
      xref
      0 1
      0000000000 65535 f
      trailer
      << /Size 1 /Root 1 0 R >>
      startxref
      9
      %%EOF
    EOS
    system bin/"pdfc", "test.pdf"
  end
end
