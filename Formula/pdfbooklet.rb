class Pdfbooklet < Formula
  desc "command-line utility to reorder pages in a PDF for booklet printing"
  homepage "https://github.com/sptim/pdfbooklet"
  url "https://github.com/sptim/pdfbooklet/archive/v1.0.tar.gz"
  sha256 "7cb3dfb4c380d23a2e2e8ea866af91a0bdc6dc83dd9b03f118a06225e13a485d"

  depends_on :xcode => :build

  def install
    xcodebuild "-target", "pdfbooklet", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/pdfbooklet"
    man1.install "pdfbooklet/pdfbooklet.1"
  end

  test do
    (testpath/"in.pdf").write <<-EOS.undent
    %PDF-1.5
    1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj
    2 0 obj<</Type/Pages/Count 1/Kids[3 0 R]>>endobj
    3 0 obj<</Type/Page/MediaBox[0 0 612 792]/Parent 2 0 R/Resources<<>>>>endobj
    4 0 obj<</Type/XRef/Size 5/W[1 1 1]/Root 1 0 R/Length 30/Filter/ASCIIHexDecode>>stream
    0000ff01090001340001650001b200endstream endobj
    startxref
    178
    %%EOF
    EOS
    system "#{bin}/pdfbooklet", "in.pdf", "out.pdf"
    system "/usr/bin/grep", "-q", "/Pages .*/Count 4 /", "out.pdf"
  end
end
